#
# This code was adapted from the `terraform-aws-ecs-container-definition` module from Innovation Norway, on 2019-02-20.
# Available here: https://github.com/innovationnorway/terraform-github-repository
#

module "label" {
  source     = "github.com/cloudposse/terraform-null-label.git?ref=0.25.0"
  enabled    = true
  namespace  = var.namespace
  tenant     = var.tenant
  name       = var.name
  delimiter  = var.delimiter
  attributes = var.attributes
  tags       = var.tags

  label_order         = ["namespace", "tenant", "name"]
  regex_replace_chars = "/[^a-zA-Z0-9-_]/"
}

resource "github_repository" "this" {
  name = var.use_fullname ? module.label.id : module.label.name

  description  = var.description
  homepage_url = var.homepage_url

  visibility = var.visibility

  has_issues   = var.has_issues
  has_projects = var.has_projects
  has_wiki     = var.has_wiki

  is_template = var.is_template

  allow_merge_commit = var.allow_merge_commit
  allow_squash_merge = var.allow_squash_merge
  allow_rebase_merge = var.allow_rebase_merge
  allow_auto_merge   = var.allow_auto_merge

  delete_branch_on_merge = var.delete_branch_on_merge

  auto_init          = var.auto_init
  gitignore_template = var.gitignore_template
  license_template   = var.license_template

  topics = var.topics

  archived           = var.archived
  archive_on_destroy = var.archive_on_destroy

  dynamic "pages" {
    for_each = var.pages != null ? { this = var.pages } : {}
    content {
      dynamic "source" {
        for_each = { this = pages.value["source"] }
        content {
          branch = source.value["branch"]
          path   = source.value["path"]
        }
      }
    }
  }

  dynamic "template" {
    for_each = var.template != null ? { this = var.template } : {}
    content {
      owner      = template.value["owner"]
      repository = template.value["repository"]
    }
  }

  vulnerability_alerts = var.vulnerability_alerts
}

resource "github_team_repository" "this" {
  for_each = local.teams

  repository = github_repository.this.name

  team_id    = data.github_team.this[each.key].id
  permission = each.value
}

resource "github_repository_collaborator" "this" {
  for_each = var.collaborators

  repository = github_repository.this.name
  username   = each.key
  permission = each.value
}

resource "github_issue_label" "this" {
  for_each = local.labels

  repository = github_repository.this.name

  name  = each.value["name"]
  color = each.value["color"]

  description = each.value["description"]
}

resource "github_branch_protection" "this" {
  for_each = var.default_branch_protection_enabled ? toset(["default"]) : []

  repository_id = github_repository.this.node_id
  pattern       = github_repository.this.default_branch

  enforce_admins                  = local.rendered_default_branch_protection["enforce_admins"]
  allows_deletions                = local.rendered_default_branch_protection["allows_deletions"]
  allows_force_pushes             = local.rendered_default_branch_protection["allows_force_pushes"]
  require_signed_commits          = local.rendered_default_branch_protection["require_signed_commits"]
  required_linear_history         = local.rendered_default_branch_protection["required_linear_history"]
  require_conversation_resolution = local.rendered_default_branch_protection["require_conversation_resolution"]
  push_restrictions               = local.rendered_default_branch_protection["push_restrictions"]

  required_status_checks {
    strict   = local.rendered_default_branch_protection["required_status_checks"]["strict"]
    contexts = local.rendered_default_branch_protection["required_status_checks"]["contexts"]
  }

  required_pull_request_reviews {
    dismiss_stale_reviews           = local.rendered_default_branch_protection["required_pull_request_reviews"]["dismiss_stale_reviews"]
    restrict_dismissals             = local.rendered_default_branch_protection["required_pull_request_reviews"]["restrict_dismissals"]
    dismissal_restrictions          = local.rendered_default_branch_protection["required_pull_request_reviews"]["dismissal_restrictions"]
    require_code_owner_reviews      = local.rendered_default_branch_protection["required_pull_request_reviews"]["require_code_owner_reviews"]
    required_approving_review_count = local.rendered_default_branch_protection["required_pull_request_reviews"]["required_approving_review_count"]
  }
}

resource "github_actions_secret" "this" {
  for_each = var.secrets

  repository = github_repository.this.name

  secret_name     = each.key
  encrypted_value = lookup(each.value, "encrypted_value", null)
  plaintext_value = lookup(each.value, "plaintext_value", null)
}

resource "github_repository_webhook" "this" {
  for_each = local.rendered_webhooks

  repository = github_repository.this.name

  active = each.value["active"]
  events = each.value["events"]

  configuration {
    url          = each.value["configuration"]["url"]
    content_type = each.value["configuration"]["content_type"]
    secret       = each.value["configuration"]["secret"]
    insecure_ssl = each.value["configuration"]["insecure_ssl"]
  }
}
