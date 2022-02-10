output "repository" {
  value       = github_repository.this
  description = "Created repository"
}

output "repository_branch_protection" {
  value       = github_branch_protection.this
  description = "Default branch protection settings"
}

output "repository_webhook_urls" {
  description = "Webhook URLs"
  value       = { for k, v in github_repository_webhook.this : k => v.url }
}
