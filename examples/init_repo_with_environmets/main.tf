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
        TEST_SECRET = {},
        PLAIN_TEXT_SECRET = {
          plaintext_value = sensitive("some_secret")
        }
      }
    },
    test = {
      secrets = {
        ENCRYPTED_SECRET = {
          # Value encrypted with organization public key
          # Public key: https://docs.github.com/en/rest/reference/actions#get-an-organization-public-key
          # Ecnryption: https://docs.github.com/en/rest/reference/actions#create-or-update-an-organization-secret
          encrypted_value = "P1wD+Byzy0JvL77qILs1gLj1wpDIDYIKGcHJbuILlTq3lNLgxDQuHXLVYknj2nx6uaeNGx3AmgsO+Nak"
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
