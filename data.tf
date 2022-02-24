data "github_team" "this" {
  for_each = local.team_names

  slug = each.key
}
