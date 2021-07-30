variable "name" {
  type        = string
  description = "The name of the repository."
}

variable "namespace" {
  description = "Namespace (e.g. `ops`"
}

variable "stage" {
  description = "Stage (e.g. `prod`, `dev`, `staging`)"
}

variable "enabled" {
  description = "Set to false to prevent the module from creating any resources"
  default     = "true"
}

variable "use_fullname" {
  type        = string
  default     = "true"
  description = "Set 'true' to use `namespace-stage-name` for ecr repository name, else `name`"
}

variable "delimiter" {
  type        = string
  default     = "-"
  description = "Delimiter to be used between `name`, `namespace`, `stage`, etc."
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

variable "private" {
  type        = string
  default     = "true"
  description = "Set to `false` to create a public (e.g. open source) repository."
}

variable "has_issues" {
  type        = string
  default     = "true"
  description = "Set  to `false` to disable the GitHub Issues features on the repository."
}

variable "has_projects" {
  type        = string
  default     = "false"
  description = "Set  to `true` to enable the GitHub Projects features on the repository."
}

variable "has_wiki" {
  type        = string
  default     = "false"
  description = "Set  to `true` to enable the GitHub Wiki features on the repository."
}

variable "allow_merge_commit" {
  type        = string
  default     = "false"
  description = "Set  to `false` to disable merge commits on the repository."
}

variable "allow_squash_merge" {
  type        = string
  default     = "true"
  description = "Set  to `false` to disable squash merges on the repository."
}

variable "allow_rebase_merge" {
  type        = string
  default     = "false"
  description = "Set  to `false` to disable rebase merges on the repository."
}

variable "auto_init" {
  type        = string
  default     = "true"
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
  description = "The name of the default branch of the repository. NOTE: This can only be set after a repository has already been created, and after a correct reference has been created for the target branch inside the repository."
}

variable "archived" {
  type        = string
  default     = "false"
  description = "Specifies if the repository should be archived."
}

variable "teams" {
  type        = list(object({
    name      = string
    permission= string
  }))
  default     = []
  description = "List of teams on the repository."
}

variable "default_branch_protection_enabled" {
  description = "Do we want to enable branch protection for the default branch"
  type        = string
  default     = "false"
}

variable "default_branch_protection_enforce_admins" {
  description = "Boolean, setting this to true enforces status checks for repository administrators."
  type        = string
  default     = "false"
}

variable "default_branch_protection_required_status_checks_strict" {
  description = "Require branches to be up to date before merging. Defaults to false."
  type        = string
  default     = "true"
}

variable "default_branch_protection_required_status_checks_contexts" {
  description = "List of status checks, e.g. travis"
  type        = list(string)
  default     = []
}

variable "default_branch_protection_dismiss_stale_reviews" {
  description = "Dismiss approved reviews automatically when a new commit is pushed. Defaults to false."
  type        = string
  default     = "true"
}

variable "default_branch_protection_require_code_owner_reviews" {
  description = "Require an approved review in pull requests including files with a designated code owner. Defaults to false."
  type        = string
  default     = "false"
}

variable "default_branch_protection_restrictions_teams" {
  description = "The list of team slugs with push access. Always use slug of the team, not its name. Each team already has to have access to the repository."
  type        = list(string)
  default     = []
}

variable "issue_labels" {
  type        = list(object({
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
