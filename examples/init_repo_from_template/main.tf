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

# This will create `terraform-example-test-template` repository
module "template" {
  source = "../../"

  token = var.token
  owner = var.owner

  namespace   = "terraform"
  tenant      = "example"
  name        = "test-template"
  description = "Terraform module example github template repository"

  visibility  = "private"
  is_template = true

  default_branch_protection_enabled = false
}

# This will create `terraform-example-test-clone` repository using template `terraform-example-test-template`
module "clone" {
  source = "../../"

  namespace   = "terraform"
  tenant      = "example"
  name        = "test-clone"
  description = "Terraform module example github clone repository"

  visibility = "private"
  template = {
    owner      = var.github_owner
    repository = module.template.repository.name
  }

  default_branch_protection_enabled = false
}

output "template" {
  value = module.template.repository
}

output "clone" {
  value = module.clone.repository
}
