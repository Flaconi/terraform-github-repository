variable "github_token" {
  type    = "string"
  default = ""
}

variable "github_organization" {
  type    = "string"
  default = ""
}

provider "github" {
  token        = "${var.github_token}"
  organization = "${var.github_organization}"
}

locals {
  teams = [
    {
      name       = "engineering"
      permission = "push"
    },
    {
      name       = "devops"
      permission = "push"
    },
    {
      name       = "ext-devops"
      permission = "push"
    },
  ]
}

module "example_repo" {
  source = "../../"

  name = "example-test"

  description = "Terraform module github repository testing "
  namespace   = "namespace"
  stage       = "stage"

  private = true

  teams = "${local.teams}"

  allow_merge_commit = "true"
  allow_squash_merge = "true"
  allow_rebase_merge = "true"

  default_branch_protection_enforce_admins                  = "true"
  default_branch_protection_enabled                         = "true"
  default_branch_protection_required_status_checks_contexts = ["Travis CI - Branch", "Travis CI - Pull Request"]
  default_branch_protection_require_code_owner_reviews      = "true"
}
