data "github_team" "main" {
  count = length(var.teams)

  slug = replace(lower(var.teams[count.index]["name"]), " ", "-")
}
