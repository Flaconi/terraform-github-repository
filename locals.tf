locals {
  team_slugs = { for team in var.teams :
    replace(lower(team["name"]), " ", "-") => team
  }

  team_names = toset([for slug, team in local.team_slugs :
    slug if team["id"] == null
  ])

  team_ids = { for slug, team in local.team_slugs :
    slug => {
      id         = team["id"] != null ? team["id"] : data.github_team.this[slug].id
      permission = team["permission"]
    }
  }

  labels = { for label in var.issue_labels :
    replace(lower(label["name"]), " ", "-") => {
      name        = label["name"]
      color       = label["color"]
      description = label["description"]
    }
  }

  deploy_keys = { for key in var.deploy_keys :
    replace(lower(key["title"]), " ", "-") => {
      title     = key["title"]
      key       = key["key"]
      read_only = key["read_only"]
    }
  }

  environments = { for name, env in var.environments :
    replace(lower(name), " ", "-") => {
      name          = name
      reviewers     = env["reviewers"]
      branch_policy = env["branch_policy"]
    }
  }

  rendered_environments_secrets = merge([for ename, env in var.environments :
    { for sname, secret in(env["secrets"] != null ? env["secrets"] : {}) :
      "${replace(lower(ename), " ", "-")}:${sname}" => merge(secret, {
        environment = ename
        secret_name = sname
      })
    }
  ]...)

  # These settings are default for branch protection
  branch_protection_defaults = {
    enforce_admins                  = true
    allows_deletions                = false
    allows_force_pushes             = false
    require_signed_commits          = true
    required_linear_history         = false
    require_conversation_resolution = false
    push_restrictions               = []
    required_status_enabled         = true
    required_status_checks = {
      strict   = true
      contexts = []
    }
    required_pull_request_enabled = true
    required_pull_request_reviews = {
      dismiss_stale_reviews           = true
      restrict_dismissals             = false
      dismissal_restrictions          = []
      require_code_owner_reviews      = true
      required_approving_review_count = 1
    }
  }

  # Combine defaults with input parameters
  # TODO: refactor if `deepmerge` is implemented https://github.com/hashicorp/terraform/issues/31815
  # When you use `optional()` parameters all keys are defined and values are set to `null`.
  # In this case `lookup` all the time return `null` when you reference the key.
  # You have to use `if .. else` condition to sort it out.
  clean_default_branch_protection = {
    for k, v in var.default_branch_protection :
    k => (v != null ? v : local.branch_protection_defaults[k])
  }
  clean_branch_protection = var.branch_protection != null ? {
    for name, settings in var.branch_protection :
    name => {
      for k, v in settings :
      k => (v != null ? v : local.branch_protection_defaults[k])
    }
  } : {}
  rendered_branch_protection = merge(
    # Branch protection rules for default branch
    var.default_branch_protection_enabled ? {
      default = {
        enforce_admins                  = local.clean_default_branch_protection["enforce_admins"]
        allows_deletions                = local.clean_default_branch_protection["allows_deletions"]
        allows_force_pushes             = local.clean_default_branch_protection["allows_force_pushes"]
        require_signed_commits          = local.clean_default_branch_protection["require_signed_commits"]
        required_linear_history         = local.clean_default_branch_protection["required_linear_history"]
        require_conversation_resolution = local.clean_default_branch_protection["require_conversation_resolution"]
        push_restrictions               = local.clean_default_branch_protection["push_restrictions"]
        required_status_enabled         = local.clean_default_branch_protection["required_status_enabled"]
        required_status_checks = {
          for k, v in local.clean_default_branch_protection["required_status_checks"] :
          k => (v != null ? v : local.branch_protection_defaults["required_status_checks"][k])
        }
        required_pull_request_enabled = local.clean_default_branch_protection["required_pull_request_enabled"]
        required_pull_request_reviews = {
          for k, v in local.clean_default_branch_protection["required_pull_request_reviews"] :
          k => (v != null ? v : local.branch_protection_defaults["required_pull_request_reviews"][k])
        }
      }
    } : {},
    # Additional branch protection rules
    var.branch_protection != null ? {
      for name, settings in var.branch_protection :
      name => {
        enforce_admins                  = local.clean_branch_protection[name]["enforce_admins"]
        allows_deletions                = local.clean_branch_protection[name]["allows_deletions"]
        allows_force_pushes             = local.clean_branch_protection[name]["allows_force_pushes"]
        require_signed_commits          = local.clean_branch_protection[name]["require_signed_commits"]
        required_linear_history         = local.clean_branch_protection[name]["required_linear_history"]
        require_conversation_resolution = local.clean_branch_protection[name]["require_conversation_resolution"]
        push_restrictions               = local.clean_branch_protection[name]["push_restrictions"]
        required_status_enabled         = local.clean_branch_protection[name]["required_status_enabled"]
        required_status_checks = {
          for k, v in local.clean_branch_protection[name]["required_status_checks"] :
          k => (v != null ? v : local.branch_protection_defaults["required_status_checks"][k])
        }
        required_pull_request_enabled = local.clean_branch_protection[name]["required_pull_request_enabled"]
        required_pull_request_reviews = {
          for k, v in local.clean_branch_protection[name]["required_pull_request_reviews"] :
          k => (v != null ? v : local.branch_protection_defaults["required_pull_request_reviews"][k])
        }
      }
    } : {}
  )

  # These settings are default for webhooks
  webhook_defaults = {
    active = true
    configuration = {
      insecure_ssl = false
    }
  }
  # Combine defaults with input parameters
  rendered_webhooks = {
    for v in var.webhooks : v["ident"] => {
      active = v["active"] != null ? v["active"] : local.webhook_defaults["active"]
      events = v["events"]
      configuration = {
        url          = v["configuration"]["url"]
        content_type = v["configuration"]["content_type"]
        secret       = v["configuration"]["secret"]
        insecure_ssl = v["configuration"]["insecure_ssl"] != null ? v["configuration"]["insecure_ssl"] : local.webhook_defaults["configuration"]["insecure_ssl"]
      }
    }
  }
}
