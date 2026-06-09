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

data "github_user" "this" {
  username = ""
}

# This will create `terraform-example-test-environments` repository
module "example" {
  source = "../../"

  namespace   = "terraform"
  tenant      = "example"
  name        = "test-environments"
  description = "Terraform module example github repository"

  visibility = "public"

  gitignore_template = "Terraform"
  license_template   = "mit"

  vulnerability_alerts = true

  default_branch_protection_enabled = false

  environments = {
    dev = {
      reviewers = {
        users = [data.github_user.this.id]
      }
      secrets = {
        PLAIN_TEXT_SECRET = {
          value = sensitive("some_secret")
        }
      }
    },
    test = {
      secrets = {
        ENCRYPTED_SECRET = {
          # Value encrypted with environment public key
          # Public key: https://docs.github.com/en/rest/actions/secrets?apiVersion=2026-03-10#get-an-environment-public-key
          # Encryption: https://docs.github.com/en/rest/guides/encrypting-secrets-for-the-rest-api?apiVersion=2026-03-10
          value_encrypted = "PkNAGcg+bWWDQn7YOLtmfsD9VrvOcTm2IZ1HogcjpDOmCzn9Z1AThxK21ZhrtNgZyvGmchQBACZFAdPEz759Wg=="
        }
      }
    }
    prod = {
      branch_policy = {
        protected_branches = true
      }
    }
  }
}

output "repository" {
  value = module.example.repository
}

output "environments" {
  value = module.example.environments
}

output "environments_secrets" {
  value = module.example.environments_secrets
}
