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

# This will create `terraform-example-test-webhooks` repository
module "example" {
  source = "../../"

  namespace   = "terraform"
  tenant      = "example"
  name        = "test-webhooks"
  description = "Terraform module example github repository"

  visibility = "private"

  gitignore_template = "Terraform"
  license_template   = "mit"

  vulnerability_alerts = true

  default_branch_protection_enabled = false

  webhooks = [
    {
      ident  = "google"
      events = ["issues"]
      configuration = {
        url          = "https://google.de/"
        content_type = "form"
        insecure_ssl = false
      }
    },
    {
      ident  = "github"
      active = false
      events = ["pull_request", "release"]
      configuration = {
        url          = "https://github.com/"
        content_type = "json"
        secret       = "SOME-VERY-SECRET-STRING"
      }
    }
  ]
}

output "repository" {
  value = module.example.repository
}

output "webhook_urls" {
  value     = module.example.repository_webhook_urls
}
