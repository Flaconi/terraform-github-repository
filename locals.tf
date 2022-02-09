locals {
  teams = { for team, permission in var.teams :
    replace(lower(team), " ", "-") => permission
  }

  labels = { for label in var.issue_labels :
    replace(lower(label["name"]), " ", "-") => {
      name        = label["name"]
      color       = label["color"]
      description = label["description"]
    }
  }

  # These settings are default for branch protection
  default_branch_protection = {
    enforce_admins                  = true
    allows_deletions                = false
    allows_force_pushes             = false
    require_signed_commits          = true
    required_linear_history         = false
    require_conversation_resolution = false
    push_restrictions               = []
    required_status_checks = {
      strict   = true
      contexts = []
    }
    required_pull_request_reviews = {
      dismiss_stale_reviews           = true
      restrict_dismissals             = false
      dismissal_restrictions          = []
      require_code_owner_reviews      = true
      required_approving_review_count = 1
    }
  }

  # Combine defaults with input parameters
  # TODO: refactor if `deepmerge` is implemented https://github.com/hashicorp/terraform/issues/24987
  # When you use `optional()` parameters all keys are defined and values are set to `null`.
  # In this case `lookup` all the time return `null` when you reference the key.
  # You have to use `if .. else` condition to sort it out.
  required_status_checks        = var.default_branch_protection["required_status_checks"] != null ? var.default_branch_protection["required_status_checks"] : local.default_branch_protection["required_status_checks"]
  required_pull_request_reviews = var.default_branch_protection["required_pull_request_reviews"] != null ? var.default_branch_protection["required_pull_request_reviews"] : local.default_branch_protection["required_pull_request_reviews"]
  rendered_default_branch_protection = {
    enforce_admins                  = var.default_branch_protection["enforce_admins"] != null ? var.default_branch_protection["enforce_admins"] : local.default_branch_protection["enforce_admins"]
    allows_deletions                = var.default_branch_protection["allows_deletions"] != null ? var.default_branch_protection["allows_deletions"] : local.default_branch_protection["allows_deletions"]
    allows_force_pushes             = var.default_branch_protection["allows_force_pushes"] != null ? var.default_branch_protection["allows_force_pushes"] : local.default_branch_protection["allows_force_pushes"]
    require_signed_commits          = var.default_branch_protection["require_signed_commits"] != null ? var.default_branch_protection["require_signed_commits"] : local.default_branch_protection["require_signed_commits"]
    required_linear_history         = var.default_branch_protection["required_linear_history"] != null ? var.default_branch_protection["required_linear_history"] : local.default_branch_protection["required_linear_history"]
    require_conversation_resolution = var.default_branch_protection["require_conversation_resolution"] != null ? var.default_branch_protection["require_conversation_resolution"] : local.default_branch_protection["require_conversation_resolution"]
    push_restrictions               = var.default_branch_protection["push_restrictions"] != null ? var.default_branch_protection["push_restrictions"] : local.default_branch_protection["push_restrictions"]
    required_status_checks = {
      strict   = local.required_status_checks["strict"] != null ? local.required_status_checks["strict"] : local.default_branch_protection["required_status_checks"]["strict"]
      contexts = local.required_status_checks["contexts"] != null ? local.required_status_checks["contexts"] : local.default_branch_protection["required_status_checks"]["contexts"]
    }
    required_pull_request_reviews = {
      dismiss_stale_reviews           = local.required_pull_request_reviews["dismiss_stale_reviews"] != null ? local.required_pull_request_reviews["dismiss_stale_reviews"] : local.default_branch_protection["required_pull_request_reviews"]["dismiss_stale_reviews"]
      restrict_dismissals             = local.required_pull_request_reviews["restrict_dismissals"] != null ? local.required_pull_request_reviews["restrict_dismissals"] : local.default_branch_protection["required_pull_request_reviews"]["restrict_dismissals"]
      dismissal_restrictions          = local.required_pull_request_reviews["dismissal_restrictions"] != null ? local.required_pull_request_reviews["dismissal_restrictions"] : local.default_branch_protection["required_pull_request_reviews"]["dismissal_restrictions"]
      require_code_owner_reviews      = local.required_pull_request_reviews["require_code_owner_reviews"] != null ? local.required_pull_request_reviews["require_code_owner_reviews"] : local.default_branch_protection["required_pull_request_reviews"]["require_code_owner_reviews"]
      required_approving_review_count = local.required_pull_request_reviews["required_approving_review_count"] != null ? local.required_pull_request_reviews["required_approving_review_count"] : local.default_branch_protection["required_pull_request_reviews"]["required_approving_review_count"]
    }
  }
}
