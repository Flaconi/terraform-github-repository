data "github_team" "this" {
  for_each = local.team_names

  slug = each.key
}

data "github_actions_public_key" "this" {
  count      = local.has_actions_encrypted_secrets ? 1 : 0
  repository = github_repository.this.name
}

data "github_dependabot_public_key" "this" {
  count      = local.has_dependabot_encrypted_secrets ? 1 : 0
  repository = github_repository.this.name
}

data "github_actions_environment_public_key" "this" {
  for_each = local.has_environment_encrypted_secrets

  repository  = github_repository.this.name
  environment = github_repository_environment.this[each.key].environment
}
