variable "github_token" {
  type    = string
  default = ""
}

variable "github_owner" {
  type    = string
  default = ""
}

provider "github" {
  token = var.github_token
  owner = var.github_owner
}

resource "github_team" "admins" {
  name        = "Repository Admins"
  description = "Admins for this repository"
  privacy     = "closed"

  create_default_maintainer = true
}

# Note: You have to be an Owner of organization to destroy this resource
resource "github_team" "developers" {
  name        = "Repository Developers"
  description = "Developers for this repository"
  privacy     = "closed"

  create_default_maintainer = false
}

module "example" {
  source = "../../"

  name = "example-test-teams"

  description = "Terraform module example github repository"
  namespace   = "terraform"
  stage       = "null"

  visibility = "public"

  teams = [
    {
      name       = github_team.admins.name
      permission = "admin"
    },
    {
      name       = github_team.developers.name
      permission = "push"
    },
  ]

  allow_merge_commit = false
  allow_squash_merge = true
  allow_rebase_merge = false

  vulnerability_alerts = true

  default_branch_protection_enforce_admins                  = true
  default_branch_protection_enabled                         = true
  default_branch_protection_required_status_checks_contexts = ["Travis CI - Branch", "Travis CI - Pull Request"]
  default_branch_protection_require_code_owner_reviews      = true

  depends_on = [
    github_team.admins,
    github_team.developers
  ]
}

output "repository" {
  value = module.example.repository
}
