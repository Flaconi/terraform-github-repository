output "repository" {
  value       = github_repository.this
  description = "Created repository"
}

output "repository_branch_protection" {
  value       = github_branch_protection.this
  description = "Default branch protection settings"
}

output "repository_secrets" {
  description = "A map of create secret names"
  value = {
    for name, secret in github_actions_secret.this : name => {
      created = secret.created_at
      updated = secret.updated_at
    }
  }
}

output "dependabot_secrets" {
  description = "A map of dependabot secret names"
  value = {
    for name, secret in github_dependabot_secret.this : name => {
      created = secret.created_at
      updated = secret.updated_at
    }
  }
}

output "repository_webhook_urls" {
  description = "Webhook URLs"
  value       = { for k, v in github_repository_webhook.this : k => v.url }
}
