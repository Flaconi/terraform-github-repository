variable "name" {
  type        = string
  description = "The name of the repository."
}

variable "namespace" {
  type        = string
  default     = null
  description = "Namespace, e.g. `terraform`, `product`, `mobile` etc."
}

variable "tenant" {
  type        = string
  default     = null
  description = "A customer identifier, indicating who this instance of a resource is for. Could be used for application grouping."
}

variable "use_fullname" {
  type        = bool
  default     = true
  description = "Set 'true' to use `namespace-tenant-name` for github repository name, else `name`"
}

variable "delimiter" {
  type        = string
  default     = "-"
  description = "Delimiter to be used between `name`, `namespace`, `tenant`, etc."
}

variable "attributes" {
  type        = list(string)
  default     = []
  description = "Additional attributes (e.g. `policy` or `role`)"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. `map('BusinessUnit','XYZ')`)"
}

variable "description" {
  type        = string
  default     = ""
  description = "A description of the repository."
}

variable "homepage_url" {
  type        = string
  default     = ""
  description = "URL of a page describing the project."
}

variable "visibility" {
  type        = string
  default     = "private"
  description = "Set to `public` to create a public (e.g. open source) repository."
}

variable "has_downloads" {
  type        = bool
  default     = null
  description = "Set to `true` to enable the (deprecated) downloads features on the repository."
}

variable "has_issues" {
  type        = bool
  default     = true
  description = "Set  to `false` to disable the GitHub Issues features on the repository."
}

variable "has_projects" {
  type        = bool
  default     = false
  description = "Set  to `true` to enable the GitHub Projects features on the repository."
}

variable "has_wiki" {
  type        = bool
  default     = false
  description = "Set  to `true` to enable the GitHub Wiki features on the repository."
}

variable "is_template" {
  type        = bool
  default     = false
  description = "Set to `true` to tell GitHub that this is a template repository."
}

variable "allow_merge_commit" {
  type        = bool
  default     = false
  description = "Set  to `false` to disable merge commits on the repository."
}

variable "allow_squash_merge" {
  type        = bool
  default     = true
  description = "Set  to `false` to disable squash merges on the repository."
}

variable "allow_rebase_merge" {
  type        = bool
  default     = false
  description = "Set  to `false` to disable rebase merges on the repository."
}

variable "allow_update_branch" {
  type        = bool
  default     = false
  description = "Set to `true` to always suggest updating pull request branches."
}

variable "allow_auto_merge" {
  type        = bool
  default     = false
  description = "Set to `true` to allow auto-merging pull requests on the repository."
}

variable "squash_merge_commit_title" {
  type        = string
  default     = "COMMIT_OR_PR_TITLE"
  description = "Can be `PR_TITLE` or `COMMIT_OR_PR_TITLE` for a default squash merge commit title."
}

variable "squash_merge_commit_message" {
  type        = string
  default     = "COMMIT_MESSAGES"
  description = "Can be `PR_BODY`, `COMMIT_MESSAGES`, or `BLANK` for a default squash merge commit message."
}

variable "merge_commit_title" {
  type        = string
  default     = "MERGE_MESSAGE"
  description = "Can be `PR_TITLE` or `MERGE_MESSAGE` for a default merge commit title."
}

variable "merge_commit_message" {
  type        = string
  default     = "PR_TITLE"
  description = "Can be `PR_BODY`, `PR_TITLE`, or `BLANK` for a default merge commit message."
}

variable "delete_branch_on_merge" {
  type        = bool
  default     = true
  description = "Automatically delete head branch after a pull request is merged."
}

variable "auto_init" {
  type        = bool
  default     = true
  description = "Meaningful only during create; set  to `true` to produce an initial commit in the repository."
}

variable "license_template" {
  type        = string
  default     = ""
  description = "Meaningful only during create, will be ignored after repository creation. Use the name of the template without the extension. For example, \"Terraform\"."
}

variable "gitignore_template" {
  type        = string
  default     = ""
  description = "Meaningful only during create, will be ignored after repository creation. Use the name of the template without the extension. For example, \"Terraform\"."
}

variable "archived" {
  type        = bool
  default     = false
  description = "Specifies if the repository should be archived."
}

variable "archive_on_destroy" {
  type        = bool
  default     = false
  description = "Set to `true` to archive the repository instead of deleting on destroy."
}

variable "actions_repository_access_level" {
  type        = string
  default     = null
  description = "This resource allows you to set the access level of a non-public repositories actions and reusable workflows for use in other repositories."

  validation {
    condition = var.actions_repository_access_level != null ? contains([
      "none", "user", "organization", "enterprise"
    ], var.actions_repository_access_level) : true
    error_message = "Possible values are `none`, `user`, `organization` or `enterprise`."
  }
}

variable "teams" {
  type = list(object({
    id         = optional(string)
    name       = string
    permission = string
  }))
  default     = []
  description = "List of teams with permissions. Specify Team ID to avoid additional requests to GitHub API."

  validation {
    condition = length(var.teams) > 0 ? alltrue([
      for team in var.teams :
      contains(["pull", "push", "maintain", "triage", "admin"], team["permission"])
    ]) : true
    error_message = "Only \"pull\", \"push\", \"maintain\", \"triage\" or \"admin\" permissions are allowed."
  }
}

variable "collaborators" {
  type        = map(string)
  default     = {}
  description = "Map of users with permissions."

  validation {
    condition = length(var.collaborators) > 0 ? alltrue([
      for permission in distinct(values(var.collaborators)) :
      contains(["pull", "push", "maintain", "triage", "admin"], permission)
    ]) : true
    error_message = "Only \"pull\", \"push\", \"maintain\", \"triage\" or \"admin\" permissions are allowed."
  }
}

variable "pages" {
  type = object({
    build_type = optional(string, "legacy")
    source = optional(object({
      branch = string
      path   = string
    }))
  })
  default = null
  validation {
    condition     = var.pages == null ? true : var.pages.build_type == "legacy" ? try(var.pages.source.branch, "") != "" && try(var.pages.source.path, "") != "" : true
    error_message = "When build type is legacy for pages source branch and path are required."
  }
  description = "The repository's GitHub Pages configuration."
}

variable "default_branch" {
  type        = string
  default     = "main"
  description = "The repository's default branch. The branch should exist prio to apply."
}

variable "default_branch_protection_enabled" {
  type        = bool
  default     = true
  description = "Set to `false` if you want to disable branch protection for default branch"
}

variable "rulesets" {
  type = map(object({
    required_linear_history = optional(bool, true)
    deletion                = optional(bool, true)
    creation                = optional(bool, true)
    update                  = optional(bool, false)
    target                  = optional(string, "branch")
    enforcement             = optional(string, "active")
    includes                = optional(list(string), ["~DEFAULT_BRANCH"])
    excludes                = optional(list(string), [])
    non_fast_forward        = optional(bool, true)
    required_signatures     = optional(bool, true)
    bypass_actors = optional(map(object({
      actor_id    = number
      actor_type  = string
      bypass_mode = optional(string, "always")
    })), {})
    pull_request = optional(object({
      enabled                           = optional(bool, true)
      dismiss_stale_reviews_on_push     = optional(bool, true)
      require_code_owner_review         = optional(bool, true)
      required_approving_review_count   = optional(number, 1)
      required_review_thread_resolution = optional(bool, true)
      require_last_push_approval        = optional(bool, true)
    }), {})
    required_status_checks = optional(object({
      enabled                              = optional(bool, true)
      strict_required_status_checks_policy = optional(bool, false)
      contexts = optional(list(object({
        integration_id = optional(number, 0)
        context        = string
      })), [])
    }))
  }))
  default = {}
}

variable "default_branch_protection" {
  type = object({
    enforce_admins                  = optional(bool, true)
    allows_deletions                = optional(bool, false)
    allows_force_pushes             = optional(bool, false)
    require_signed_commits          = optional(bool, true)
    required_linear_history         = optional(bool, false)
    require_conversation_resolution = optional(bool, false)
    restrict_pushes = optional(object({
      blocks_creations = optional(bool, false)
      push_allowances  = optional(list(string), [])
    }), {})
    required_status_enabled = optional(bool, true)
    required_status_checks = optional(object({
      strict   = optional(bool, true)
      contexts = optional(list(string), [])
    }), {})
    required_pull_request_enabled = optional(bool, true)
    required_pull_request_reviews = optional(object({
      dismiss_stale_reviews           = optional(bool, true)
      restrict_dismissals             = optional(bool, false)
      dismissal_restrictions          = optional(list(string), [])
      pull_request_bypassers          = optional(list(string), [])
      require_code_owner_reviews      = optional(bool, true)
      required_approving_review_count = optional(number, 1)
    }), {})
  })
  default     = {}
  description = "Default branch protection settings."
}

variable "branch_protection" {
  type = map(object({
    enforce_admins                  = optional(bool, true)
    allows_deletions                = optional(bool, false)
    allows_force_pushes             = optional(bool, false)
    require_signed_commits          = optional(bool, true)
    required_linear_history         = optional(bool, false)
    require_conversation_resolution = optional(bool, false)
    restrict_pushes = optional(object({
      blocks_creations = optional(bool, false)
      push_allowances  = optional(list(string), [])
    }), {})
    required_status_enabled = optional(bool, true)
    required_status_checks = optional(object({
      strict   = optional(bool, true)
      contexts = optional(list(string), [])
    }), {})
    required_pull_request_enabled = optional(bool, true)
    required_pull_request_reviews = optional(object({
      dismiss_stale_reviews           = optional(bool, true)
      restrict_dismissals             = optional(bool, false)
      dismissal_restrictions          = optional(list(string), [])
      pull_request_bypassers          = optional(list(string), [])
      require_code_owner_reviews      = optional(bool, true)
      required_approving_review_count = optional(number, 1)
    }), {})
  }))
  default     = {}
  description = "Branch protection settings. Use to set protection rules for branches different to default branch."
}

variable "issue_labels" {
  type = list(object({
    name        = string
    color       = string
    description = string
  }))
  default     = []
  description = "List of issue labels on the repository."
}

variable "secrets" {
  type = map(object({
    encrypted_value = optional(string)
    plaintext_value = optional(string)
  }))
  default     = {}
  description = "Repository secrets."

  validation {
    condition = length(var.secrets) > 0 ? alltrue([
      for k, v in var.secrets : (v["encrypted_value"] == null || v["plaintext_value"] == null)
    ]) : true
    error_message = "Either encrypted or plaintext value should be set, but not both."
  }
}

variable "bot_secrets" {
  type = map(object({
    encrypted_value = optional(string)
    plaintext_value = optional(string)
  }))
  default     = {}
  description = "Repository dependabot secrets."

  validation {
    condition = length(var.bot_secrets) > 0 ? alltrue([
      for k, v in var.bot_secrets : (v["encrypted_value"] == null || v["plaintext_value"] == null)
    ]) : true
    error_message = "Either encrypted or plaintext value should be set, but not both."
  }
}

variable "deploy_keys" {
  type = list(object({
    title     = string
    key       = string
    read_only = bool
  }))
  default     = []
  description = "List of deploy keys configurations."
}

variable "environments" {
  type = map(object({
    reviewers = optional(object({
      teams = optional(list(string), [])
      users = optional(list(string), [])
    }))
    branch_policy = optional(object({
      protected_branches     = optional(bool, false)
      custom_branch_policies = optional(bool, false)
    }))
    secrets = optional(map(object({
      encrypted_value = optional(string)
      plaintext_value = optional(string)
    })))
  }))
  default     = {}
  description = "Repository environments."

  validation {
    condition = length(var.environments) > 0 ? alltrue(flatten([
      for n, e in var.environments : [
        for k, v in e.secrets : (v["encrypted_value"] == null || v["plaintext_value"] == null)
      ] if e.secrets != null
    ])) : true
    error_message = "Either encrypted or plaintext value should be set, but not both."
  }
}

variable "topics" {
  type        = list(string)
  default     = []
  description = "A list of topics to add to the repository."
}

variable "template" {
  type = object({
    owner      = string
    repository = string
  })
  default     = null
  description = "Use a template repository to create this repository."
}

variable "vulnerability_alerts" {
  type        = bool
  default     = false
  description = "Set to `true` to enable security alerts for vulnerable dependencies. Enabling requires alerts to be enabled on the owner level."
}

variable "webhooks" {
  type = list(object({
    ident  = string # some unique string to identify this webhook
    active = optional(bool, true)
    events = list(string)
    configuration = object({
      url          = string
      content_type = string
      secret       = optional(string)
      insecure_ssl = optional(bool, false)
    })
  }))
  default     = []
  description = "List of webhook configurations."

  validation {
    condition = length(var.webhooks) > 0 ? alltrue([
      for w in var.webhooks : length(w["events"]) > 0
    ]) : true
    error_message = "You have to specify at least one trigger event for each webhook."
  }
}
