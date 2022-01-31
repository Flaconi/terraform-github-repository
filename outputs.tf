output "name" {
  value = github_repository.main[0].name

  description = "The name of the repository."
}

output "full_name" {
  value = github_repository.main[0].full_name

  description = "A string of the form \"orgname/reponame\"."
}

output "html_url" {
  value = github_repository.main[0].html_url

  description = "URL to the repository on the web."
}

output "ssh_clone_url" {
  value = github_repository.main[0].ssh_clone_url

  description = "URL that can be provided to \"git clone\" to clone the repository via SSH."
}

output "http_clone_url" {
  value = github_repository.main[0].http_clone_url

  description = "URL that can be provided to \"git clone\" to clone the repository via HTTPS."
}

output "git_clone_url" {
  value = github_repository.main[0].git_clone_url

  description = "URL that can be provided to \"git clone\" to clone the repository anonymously via the git protocol."
}

output "default_branch" {
  value = github_repository.main[0].default_branch

  description = "The name of the default branch of the repository."
}

output "repository" {
  value = github_repository.main[0]

  description = "Created repository"
}
