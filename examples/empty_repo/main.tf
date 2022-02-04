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

module "example" {
  source = "../../"

  name = "example-test-empty"

  description = "Terraform module example github repository"
  namespace   = "terraform"
  stage       = "null"

  visibility = "private"

  auto_init = false

  allow_merge_commit = true
  allow_squash_merge = true
  allow_rebase_merge = true

  vulnerability_alerts = true
}

output "repository" {
  value = module.example.repository
}
