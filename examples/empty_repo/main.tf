variable "token" {
  type    = string
  default = ""
}

variable "owner" {
  type    = string
  default = ""
}

# This will create `terraform-example-test-empty` repository
module "example" {
  source = "../../"

  token = var.token
  owner = var.owner

  namespace   = "terraform"
  tenant      = "example"
  name        = "test-empty"
  description = "Terraform module example github repository"

  visibility = "private"

  auto_init = false

  allow_merge_commit = true
  allow_squash_merge = true
  allow_rebase_merge = true

  vulnerability_alerts = true

  default_branch_protection_enabled = false
}

output "repository" {
  value = module.example.repository
}
