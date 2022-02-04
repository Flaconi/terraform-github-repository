locals {
  teams = { for team in var.teams :
    replace(lower(team["name"]), " ", "-") => team["permission"]
  }

  labels = { for label in var.issue_labels :
    replace(lower(label["name"]), " ", "-") => {
      name        = label["name"]
      color       = label["color"]
      description = label["description"]
    }
  }
}
