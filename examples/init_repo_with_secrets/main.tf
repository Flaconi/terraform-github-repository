variable "token" {
  type    = string
  default = ""
}

variable "owner" {
  type    = string
  default = ""
}

# This will create `terraform-example-test-secrets` repository
module "example" {
  source = "../../"

  token = var.token
  owner = var.owner

  namespace   = "terraform"
  tenant      = "example"
  name        = "test-secrets"
  description = "Terraform module example github repository"

  visibility = "private"

  gitignore_template = "Terraform"
  license_template   = "mit"

  vulnerability_alerts = true

  default_branch_protection_enabled = false

  secrets = {
    TEST_SECRET = {},
    SOME_PLAIN_TEXT_SECRET = {
      plaintext_value = "some_secret"
    }
    ENCRYPTED_SECRET = {
      # Value encrypted with organization public key
      # Public key: https://docs.github.com/en/rest/reference/actions#get-an-organization-public-key
      # Ecnryption: https://docs.github.com/en/rest/reference/actions#create-or-update-an-organization-secret
      encrypted_value = "P1wD+Byzy0JvL77qILs1gLj1wpDIDYIKGcHJbuILlTq3lNLgxDQuHXLVYknj2nx6uaeNGx3AmgsO+Nak"
    }
  }
}

output "repository" {
  value = module.example.repository
}

output "secrets" {
  value = module.example.repository_secrets
}
