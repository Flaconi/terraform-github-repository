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
  label_value_case    = "none"
  regex_replace_chars = "/[^a-zA-Z0-9-_.]/"
}

resource "github_repository" "this" {
  name = var.use_fullname ? module.label.id : module.label.name

  description  = var.description
  homepage_url = var.homepage_url

  visibility = var.visibility

  has_downloads = var.has_downloads
  has_issues    = var.has_issues
  has_projects  = var.has_projects
  has_wiki      = var.has_wiki

  is_template = var.is_template

  allow_merge_commit  = var.allow_merge_commit
  allow_squash_merge  = var.allow_squash_merge
  allow_rebase_merge  = var.allow_rebase_merge
  allow_update_branch = var.allow_update_branch
  allow_auto_merge    = var.allow_auto_merge

  squash_merge_commit_title   = var.squash_merge_commit_title
  squash_merge_commit_message = var.squash_merge_commit_message
  merge_commit_title          = var.merge_commit_title
  merge_commit_message        = var.merge_commit_message

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
      build_type = pages.value["build_type"]
      dynamic "source" {
        for_each = pages.value["build_type"] == "legacy" ? { this = pages.value["source"] } : {}
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

  dynamic "security_and_analysis" {
    for_each = var.visibility == "public" ? { this = local.public_settings } : {}
    iterator = security

    content {
      secret_scanning {
        status = security.value["secret_scanning"]
      }
      secret_scanning_push_protection {
        status = security.value["secret_scanning_push_protection"]
      }
    }
  }
}

resource "github_branch_default" "this" {
  count = var.auto_init == true && var.archived != true ? 1 : 0

  repository = github_repository.this.name
  branch     = var.default_branch
}

resource "github_actions_repository_access_level" "this" {
  count = var.visibility == "private" && var.actions_repository_access_level != null ? 1 : 0

  repository   = github_repository.this.name
  access_level = var.actions_repository_access_level
}

resource "github_team_repository" "this" {
  for_each = local.team_ids

  repository = github_repository.this.name

  team_id    = each.value["id"]
  permission = each.value["permission"]
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
  for_each = local.rendered_branch_protection

  repository_id = github_repository.this.node_id
  pattern       = each.key == "default" ? var.default_branch : each.key

  enforce_admins                  = each.value["enforce_admins"]
  allows_deletions                = each.value["allows_deletions"]
  allows_force_pushes             = each.value["allows_force_pushes"]
  require_signed_commits          = each.value["require_signed_commits"]
  required_linear_history         = each.value["required_linear_history"]
  require_conversation_resolution = each.value["require_conversation_resolution"]

  dynamic "restrict_pushes" {
    for_each = length(each.value["restrict_pushes"]["push_allowances"]) > 0 ? ["this"] : []
    content {
      blocks_creations = each.value["restrict_pushes"]["blocks_creations"]
      push_allowances  = each.value["restrict_pushes"]["push_allowances"]
    }
  }

  dynamic "required_status_checks" {
    for_each = each.value["required_status_enabled"] ? [each.value["required_status_checks"]] : []
    iterator = checks
    content {
      strict   = checks.value["strict"]
      contexts = checks.value["contexts"]
    }
  }

  dynamic "required_pull_request_reviews" {
    for_each = each.value["required_pull_request_enabled"] ? [each.value["required_pull_request_reviews"]] : []
    iterator = reviews
    content {
      dismiss_stale_reviews           = reviews.value["dismiss_stale_reviews"]
      restrict_dismissals             = reviews.value["restrict_dismissals"]
      dismissal_restrictions          = reviews.value["dismissal_restrictions"]
      require_code_owner_reviews      = reviews.value["require_code_owner_reviews"]
      required_approving_review_count = reviews.value["required_approving_review_count"]
      pull_request_bypassers          = reviews.value["pull_request_bypassers"]
    }
  }
}

resource "github_actions_secret" "this" {
  for_each = var.secrets

  repository = github_repository.this.name

  secret_name     = each.key
  encrypted_value = sensitive(lookup(each.value, "encrypted_value", null))
  plaintext_value = sensitive(lookup(each.value, "plaintext_value", null))
}

resource "github_dependabot_secret" "this" {
  for_each = var.bot_secrets

  repository = github_repository.this.name

  secret_name     = each.key
  encrypted_value = sensitive(lookup(each.value, "encrypted_value", null))
  plaintext_value = sensitive(lookup(each.value, "plaintext_value", null))
}

resource "github_repository_deploy_key" "this" {
  for_each = local.deploy_keys

  repository = github_repository.this.name

  title     = each.value["title"]
  key       = each.value["key"]
  read_only = each.value["read_only"]
}

resource "github_repository_environment" "this" {
  for_each = local.environments

  repository  = github_repository.this.name
  environment = each.value["name"]

  dynamic "deployment_branch_policy" {
    for_each = each.value["branch_policy"] != null ? { this = each.value["branch_policy"] } : {}

    iterator = policy
    content {
      protected_branches     = policy.value["protected_branches"]
      custom_branch_policies = policy.value["custom_branch_policies"]
    }
  }

  dynamic "reviewers" {
    for_each = each.value["reviewers"] != null ? { this = each.value["reviewers"] } : {}

    content {
      teams = reviewers.value["teams"]
      users = reviewers.value["users"]
    }
  }
}

resource "github_actions_environment_secret" "this" {
  for_each = local.rendered_environments_secrets

  repository  = github_repository.this.name
  environment = each.value["environment"]

  secret_name     = each.value["secret_name"]
  encrypted_value = sensitive(lookup(each.value, "encrypted_value", null))
  plaintext_value = sensitive(lookup(each.value, "plaintext_value", null))
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

resource "github_repository_ruleset" "this" {
  for_each    = var.rulesets != null ? var.rulesets : {}
  name        = each.key
  repository  = github_repository.this.name
  target      = each.value.target
  enforcement = each.value.enforcement

  conditions {
    ref_name {
      include = each.value.includes
      exclude = each.value.excludes
    }
  }

  dynamic "bypass_actors" {
    iterator = actors
    for_each = each.value.bypass_actors
    content {
      actor_id    = actors.value.actor_id
      actor_type  = actors.value.actor_type
      bypass_mode = actors.value.bypass_mode
    }
  }

  rules {
    creation                = each.value.creation
    update                  = each.value.update
    deletion                = each.value.deletion
    non_fast_forward        = each.value.non_fast_forward
    required_linear_history = each.value.required_linear_history
    required_signatures     = each.value.required_signatures

    dynamic "pull_request" {
      for_each = each.value.pull_request.enabled ? [each.value.pull_request] : []
      iterator = reviews
      content {
        dismiss_stale_reviews_on_push     = reviews.value["dismiss_stale_reviews_on_push"]
        require_code_owner_review         = reviews.value["require_code_owner_review"]
        required_approving_review_count   = reviews.value["required_approving_review_count"]
        required_review_thread_resolution = reviews.value["required_review_thread_resolution"]
        require_last_push_approval        = reviews.value["require_last_push_approval"]
      }
    }

    dynamic "required_status_checks" {
      for_each = each.value.required_status_checks != null ? each.value.required_status_checks.enabled ? [each.value.required_status_checks] : [] : []
      iterator = checks
      content {

        dynamic "required_check" {
          for_each = checks.value.contexts
          iterator = contexts
          content {
            context        = contexts.value.context
            integration_id = contexts.value.integration_id
          }
        }
        strict_required_status_checks_policy = checks.value.strict_required_status_checks_policy
      }
    }
  }
}
