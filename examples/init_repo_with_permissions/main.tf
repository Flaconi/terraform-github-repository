variable "token" {
  type    = string
  default = ""
}

variable "owner" {
  type    = string
  default = ""
}

data "github_user" "current" {
  username = ""
}

resource "github_team" "maintainers" {
  name        = "Repository Maintainers"
  description = "Maintainers for this repository"
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

# This will create `terraform-example-test-teams` repository
module "example" {
  source = "../../"

  token = var.token
  owner = var.owner

  namespace   = "terraform"
  tenant      = "example"
  name        = "test-teams"
  description = "Terraform module example github repository"

  visibility = "public"

  teams = {
    (github_team.maintainers.name) = "maintain"
    (github_team.developers.name)  = "push"
  }

  collaborators = {
    (data.github_user.current.login) = "admin"
  }

  issue_labels = [
    {
      name        = "Custom"
      color       = "FFAA77"
      description = "This is custom label"
    },
  ]

  allow_merge_commit = false
  allow_squash_merge = true
  allow_rebase_merge = false

  vulnerability_alerts = true

  # Overwrite some settings for default branch
  default_branch_protection = {
    require_signed_commits = false
    required_status_checks = {
      contexts = ["Travis CI - Branch", "Travis CI - Pull Request"]
    }
    required_pull_request_reviews = {
      require_code_owner_reviews = false
    }
  }

  depends_on = [
    github_team.maintainers,
    github_team.developers
  ]
}

output "repository" {
  value = module.example.repository
}

output "repository_branch_protection" {
  value = module.example.repository_branch_protection
}
