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

variable "allow_auto_merge" {
  type        = bool
  default     = false
  description = "Set to `true` to allow auto-merging pull requests on the repository."
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

variable "default_branch" {
  type        = string
  default     = "master"
  description = "The name of the default branch of the repository."
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

variable "teams" {
  type = map(string)
  default     = {}
  description = "Map of organization teams with permissions."
  validation {
    condition = length(var.teams) > 0 ? alltrue([
      for permission in distinct(values(var.teams)):
        contains(["pull", "push", "maintain", "triage", "admin"], permission)
    ]) : true
    error_message = "Only \"pull\", \"push\", \"maintain\", \"triage\" or \"admin\" permissions are allowed."
  }
}

variable "collaborators" {
  type = map(string)
  default     = {}
  description = "Map of users with permissions."

  validation {
    condition = length(var.collaborators) > 0 ? alltrue([
      for permission in distinct(values(var.collaborators)):
        contains(["pull", "push", "maintain", "triage", "admin"], permission)
    ]) : true
    error_message = "Only \"pull\", \"push\", \"maintain\", \"triage\" or \"admin\" permissions are allowed."
  }
}

variable "pages" {
  type = object({
    source = object({
      branch = string
      path   = string
    })
  })
  default     = null
  description = "The repository's GitHub Pages configuration."
}

variable "default_branch_protection_enabled" {
  type        = bool
  default     = false
  description = "Do we want to enable branch protection for the default branch"
}

variable "default_branch_protection_enforce_admins" {
  type        = bool
  default     = false
  description = "Boolean, setting this to true enforces status checks for repository administrators."
}

variable "default_branch_protection_required_status_checks_strict" {
  type        = bool
  default     = true
  description = "Require branches to be up to date before merging. Defaults to false."
}

variable "default_branch_protection_required_status_checks_contexts" {
  type        = list(string)
  default     = []
  description = "List of status checks, e.g. travis"
}

variable "default_branch_protection_dismiss_stale_reviews" {
  type        = bool
  default     = true
  description = "Dismiss approved reviews automatically when a new commit is pushed. Defaults to false."
}

variable "default_branch_protection_require_code_owner_reviews" {
  type        = bool
  default     = false
  description = "Require an approved review in pull requests including files with a designated code owner. Defaults to false."
}

variable "default_branch_protection_restrictions_teams" {
  type        = list(string)
  default     = []
  description = "The list of team slugs with push access. Always use slug of the team, not its name. Each team already has to have access to the repository."
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
