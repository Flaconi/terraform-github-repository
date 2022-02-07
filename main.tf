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

resource "github_repository" "main" {
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

  repository = github_repository.main.name

  team_id    = data.github_team.main[each.key].id
  permission = each.value
}

resource "github_repository_collaborator" "this" {
  for_each = var.collaborators

  repository = github_repository.main.name
  username   = each.key
  permission = each.value
}

resource "github_issue_label" "main" {
  for_each = local.labels

  repository = github_repository.main.name

  name  = each.value["name"]
  color = each.value["color"]

  description = each.value["description"]
}

resource "github_branch_protection" "main" {
  for_each = var.default_branch_protection_enabled ? toset(["default"]) : []

  repository_id = github_repository.main.node_id
  pattern       = github_repository.main.default_branch

  enforce_admins = var.default_branch_protection_enforce_admins

  required_status_checks {
    strict   = var.default_branch_protection_required_status_checks_strict
    contexts = var.default_branch_protection_required_status_checks_contexts
  }

  required_pull_request_reviews {
    require_code_owner_reviews = var.default_branch_protection_require_code_owner_reviews
    dismiss_stale_reviews      = var.default_branch_protection_dismiss_stale_reviews
  }
}
