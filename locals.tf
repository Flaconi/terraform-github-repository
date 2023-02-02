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

  # These settings are default for public repository
  public_settings = {
    secret_scanning                 = "disabled"
    secret_scanning_push_protection = "disabled"
  }

  rendered_branch_protection = merge(
    # Branch protection rules for default branch
    var.default_branch_protection_enabled ? {
      default = var.default_branch_protection
    } : {},
    # Additional branch protection rules
    var.branch_protection
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
