locals {
  teams = { for team, permission in var.teams :
    replace(lower(team), " ", "-") => permission
  }

  labels = { for label in var.issue_labels :
    replace(lower(label["name"]), " ", "-") => {
      name        = label["name"]
      color       = label["color"]
      description = label["description"]
    }
  }
}
