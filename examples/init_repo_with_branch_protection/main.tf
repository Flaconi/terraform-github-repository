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

# This will create `terraform-example-test-branch-protection` repository
module "example" {
  source = "../../"

  namespace   = "terraform"
  tenant      = "example"
  name        = "test-branch-protection"
  description = "Terraform module example github repository"

  visibility = "public"

  vulnerability_alerts = true

  default_branch_protection_enabled = true

  branch_protection = {
    develop = {
      enforce_admins = true
    }
  }
}

output "repository" {
  value = module.example.repository
}
