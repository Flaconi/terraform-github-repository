data "github_team" "main" {
  count = var.enabled ? length(var.teams) : 0

  slug = replace(lower(var.teams[count.index]["name"]), " ", "-")
}
