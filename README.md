# GitHub Repository Module

This Terraform module manages GitHub repositories. It's a backport from https://github.com/innovationnorway/terraform-github-repository which was written for 0.12. As 0.11 does not have dynamic blocks
this module will only allow branch protection for one branch, the default branch ( defaults to master ) 

## Example Usage

### Create private repository

```hcl
module "my_pets_website_repo" {
  source = "git::https://github.com/flaconi/terraform-github-repository.git?ref=master"

  name = "my-pets-website"

  description = "My pets codebase."

  private = true

  gitignore_template = "Node"

}
```

### Create public (e.g. open source) repository

```hcl
module "terraform_my_pets_repo" {
  source  = "git::https://github.com/flaconi/terraform-github-repository.git?ref=master"

  name = "terraform-my-pets"

  description = "Terraform configuration for my pets."

  private = false

  gitignore_template = "Terraform"
  
  license_template = "mit"

}
```

### Add collaborators and teams

```hcl
module "example_repo" {
  source  = "git::https://github.com/flaconi/terraform-github-repository.git?ref=master"

  name = "example"

  description = "My example codebase"

  private = true

  teams = [
    {
      name       = "security"
      permission = "admin"
    },
  ]
}
```

### Add branch protection

```hcl
module "example_repo" {
  source  = "git::https://github.com/flaconi/terraform-github-repository.git?ref=master"

  name = "example"

  description = "My example codebase"

  private = true

  default_branch_protection_enabled = "true"

  # default_branch_protection_enforce_admins = "true"
  
  # default_branch_protection_required_status_checks_strict = "true"

  default_branch_protection_required_status_checks_contexts = ["ci/travis"]

  # default_branch_protection_dismiss_stale_reviews" = "true"

  default_branch_protection_dismissal_teams" = ["team1","team2"]
  # default_branch_protection_require_code_owner_reviews = "false"
  default_branch_protection_restrictions_teams = ["team1","team2"]
}
```

### Add issue labels

```hcl
module "example_repo" {
  source  = "git::https://github.com/flaconi/terraform-github-repository.git?ref=master"

  name = "example"

  description = "My example codebase"

  private = true

  issue_labels = [
    {
      name  = "bug"
      color = "d73a4a"
    },
    {
      name  = "wontfix"
      color = "ffffff"
    },
  ]
}
```
