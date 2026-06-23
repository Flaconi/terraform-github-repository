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

# This will create `terraform-example-test-pages` repository
module "example" {
  source = "../../"

  namespace   = "terraform"
  tenant      = "example"
  name        = "test-pages"
  description = "Terraform module example github repository with GitHub Pages"

  visibility = "public"

  auto_init = true

  vulnerability_alerts = true

  default_branch_protection_enabled = false

  pages = {
    build_type = "legacy"
    source = {
      branch = "main"
      path   = "/"
    }
  }
}

output "repository" {
  value = module.example.repository
}

