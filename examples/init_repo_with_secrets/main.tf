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

# This will create `terraform-example-test-secrets` repository
module "example" {
  source = "../../"

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
    SOME_PLAIN_TEXT_SECRET = {
      value = "some_secret"
    }

    ENCRYPTED_SECRET = {
      # Value encrypted with repository public key
      # Public key: https://docs.github.com/en/rest/actions/secrets?apiVersion=2026-03-10#get-a-repository-public-key
      # Encryption: https://docs.github.com/en/rest/guides/encrypting-secrets-for-the-rest-api?apiVersion=2026-03-10
      value_encrypted = "OYbjqv3OlAKvVqWTMVGE9ZuEKmGU8+bHBV5g+ECpWh11bUEK+JEFNqZFmBFHzFVEtIeoluqy0T+odwl75zatww=="
    }
  }

  bot_secrets = {
    BOT_PLAIN_TEXT_SECRET = {
      value = "other_secret"
    }

    BOT_ENCRYPTED_SECRET = {
      # Value encrypted with organization public key
      # Public key: https://docs.github.com/en/rest/dependabot/secrets?apiVersion=2026-03-10#get-a-repository-public-key
      # Encryption: https://docs.github.com/en/rest/guides/encrypting-secrets-for-the-rest-api?apiVersion=2026-03-10
      value_encrypted = "8PKNAUnl8H9DCY+GkAmDEEftmFi15K5DG1rldNrLMQ00ruBcBEoomD+Z8K8E1AyJu2nAfGmxfOksnrphoa1gow=="
    }
  }
}

output "repository" {
  value = module.example.repository
}

output "action_secrets" {
  value = module.example.repository_secrets
}

output "dependabot_secrets" {
  value = module.example.dependabot_secrets
}
