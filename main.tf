#
# This code was adapted from the `terraform-aws-ecs-container-definition` module from Innovation Norway, on 2019-02-20.
# Available here: https://github.com/innovationnorway/terraform-github-repository
#

module "label" {
  source     = "git::https://github.com/flaconi/terraform-null-label.git?ref=tags/0.17.0"
  enabled    = var.enabled
  namespace  = var.namespace
  stage      = var.stage
  name       = var.name
  delimiter  = var.delimiter
  attributes = var.attributes
  tags       = var.tags

  regex_replace_chars = "/[^a-zA-Z0-9-_]/"
}

resource "github_repository" "main" {
  count = var.enabled ? 1 : 0
  name  = var.use_fullname ? module.label.id : module.label.name

  description  = var.description
  homepage_url = var.homepage_url

  visibility = var.visibility

  has_issues   = var.has_issues
  has_projects = var.has_projects

  allow_merge_commit = var.allow_merge_commit
  allow_squash_merge = var.allow_squash_merge
  allow_rebase_merge = var.allow_rebase_merge

  auto_init = var.auto_init

  gitignore_template = var.gitignore_template
  license_template   = var.license_template

  topics = var.topics

  archived = var.archived
}

data "github_team" "main" {
  count = var.enabled ? length(var.teams) : 0

  slug = var.teams[count.index]["name"]
}

resource "github_team_repository" "main" {
  count = var.enabled ? length(var.teams) : 0

  repository = github_repository.main[0].name

  team_id    = element(data.github_team.main.*.id, count.index)
  permission = var.teams[count.index]["permission"]
}

resource "github_issue_label" "main" {
  count = var.enabled ? length(var.issue_labels) : 0

  repository = github_repository.main[0].name

  name  = var.issue_labels[count.index]["name"]
  color = var.issue_labels[count.index]["color"]

  description = lookup(var.issue_labels[count.index], "description", "")
}

resource "github_branch_protection" "main" {
  count         = var.enabled && var.default_branch_protection_enabled ? 1 : 0
  repository_id = github_repository.main[0].node_id
  pattern       = var.default_branch

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
