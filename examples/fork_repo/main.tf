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

data "github_user" "current" {
  username = ""
}

# This will create `terraform-example-test-origin` repository
module "origin" {
  source = "../../"

  namespace   = "terraform"
  tenant      = "example"
  name        = "test-origin"
  description = "Terraform module example github forked origin repository"

  visibility = "public"

  default_branch_protection_enabled = false
}

# This will create `terraform-example-test-clone` repository using template `terraform-example-test-template`
module "fork" {
  source = "../../"

  namespace   = "terraform"
  tenant      = "example"
  name        = "test-fork"
  description = "Terraform module example github fork repository"

  visibility = "public"
  fork = {
    owner      = var.github_owner
    repository = module.origin.repository.name
  }

  default_branch_protection_enabled = false
}

output "origin" {
  value = module.origin.repository
}

output "fork" {
  value = module.fork.repository
}
