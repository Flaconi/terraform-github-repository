output "repository" {
  value       = github_repository.main
  description = "Created repository"
}

output "repository_branch_protection" {
  value       = github_branch_protection.main
  description = "Default branch protection settings"
}
