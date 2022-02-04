data "github_team" "main" {
  for_each = local.teams

  slug = each.key
}
