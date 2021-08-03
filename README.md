# GitHub Repository Module

[![Build Status](https://travis-ci.com/Flaconi/terraform-github-repository.svg?branch=master)](https://travis-ci.com/Flaconi/terraform-github-repository)
[![Tag](https://img.shields.io/github/tag/Flaconi/terraform-github-repository.svg)](https://github.com/Flaconi/terraform-github-repository/releases)
[![license](http://img.shields.io/badge/license-MIT-brightgreen.svg)](http://opensource.org/licenses/MIT)

This Terraform module manages GitHub repositories. 
Initially it was a backport from https://github.com/innovationnorway/terraform-github-repository which was written for 0.12 and as dynamic blocks were removed to be complied with 0.11 - this module will only allow branch protection for one branch, the default branch ( defaults to master ).

## Example Usage

### Create private repository

```hcl
module "my_pets_website_repo" {
  source = "git::https://github.com/flaconi/terraform-github-repository.git?ref=master"

  name = "my-pets-website"

  description = "My pets codebase."

  visibility = "private"

  gitignore_template = "Node"

}
```

### Create public (e.g. open source) repository

```hcl
module "terraform_my_pets_repo" {
  source  = "git::https://github.com/flaconi/terraform-github-repository.git?ref=master"

  name = "terraform-my-pets"

  description = "Terraform configuration for my pets."

  visibility = "public"

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

  visibility = "private"

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

  visibility = "private"

  default_branch_protection_enabled = true

  # default_branch_protection_enforce_admins = true
  
  # default_branch_protection_required_status_checks_strict = true

  default_branch_protection_required_status_checks_contexts = ["ci/travis"]

  # default_branch_protection_dismiss_stale_reviews" = true

  default_branch_protection_dismissal_teams" = ["team1","team2"]
  # default_branch_protection_require_code_owner_reviews = false
  default_branch_protection_dismiss_stale_reviews = true
}
```

### Add issue labels

```hcl
module "example_repo" {
  source  = "git::https://github.com/flaconi/terraform-github-repository.git?ref=master"

  name = "example"

  description = "My example codebase"

  visibility = "private"

  issue_labels = [
    {
      name        = "bug"
      color       = "d73a4a"
      description = null
    },
    {
      name        = "wontfix"
      color       = "ffffff"
      description = null
    },
  ]
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| github | ~> 4 |

## Providers

| Name | Version |
|------|---------|
| github | ~> 4 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | The name of the repository. | `string` | n/a | yes |
| namespace | Namespace (e.g. `ops` | `any` | n/a | yes |
| stage | Stage (e.g. `prod`, `dev`, `staging`) | `any` | n/a | yes |
| allow\_merge\_commit | Set  to `false` to disable merge commits on the repository. | `bool` | `false` | no |
| allow\_rebase\_merge | Set  to `false` to disable rebase merges on the repository. | `bool` | `false` | no |
| allow\_squash\_merge | Set  to `false` to disable squash merges on the repository. | `bool` | `true` | no |
| archived | Specifies if the repository should be archived. | `bool` | `false` | no |
| attributes | Additional attributes (e.g. `policy` or `role`) | `list(string)` | `[]` | no |
| auto\_init | Meaningful only during create; set  to `true` to produce an initial commit in the repository. | `bool` | `true` | no |
| default\_branch | The name of the default branch of the repository. NOTE: This can only be set after a repository has already been created, and after a correct reference has been created for the target branch inside the repository. | `string` | `"master"` | no |
| default\_branch\_protection\_dismiss\_stale\_reviews | Dismiss approved reviews automatically when a new commit is pushed. Defaults to false. | `bool` | `true` | no |
| default\_branch\_protection\_enabled | Do we want to enable branch protection for the default branch | `bool` | `false` | no |
| default\_branch\_protection\_enforce\_admins | Boolean, setting this to true enforces status checks for repository administrators. | `bool` | `false` | no |
| default\_branch\_protection\_require\_code\_owner\_reviews | Require an approved review in pull requests including files with a designated code owner. Defaults to false. | `bool` | `false` | no |
| default\_branch\_protection\_required\_status\_checks\_contexts | List of status checks, e.g. travis | `list(string)` | `[]` | no |
| default\_branch\_protection\_required\_status\_checks\_strict | Require branches to be up to date before merging. Defaults to false. | `bool` | `true` | no |
| default\_branch\_protection\_restrictions\_teams | The list of team slugs with push access. Always use slug of the team, not its name. Each team already has to have access to the repository. | `list(string)` | `[]` | no |
| delimiter | Delimiter to be used between `name`, `namespace`, `stage`, etc. | `string` | `"-"` | no |
| description | A description of the repository. | `string` | `""` | no |
| enabled | Set to false to prevent the module from creating any resources | `bool` | `true` | no |
| gitignore\_template | Meaningful only during create, will be ignored after repository creation. Use the name of the template without the extension. For example, "Terraform". | `string` | `""` | no |
| has\_issues | Set  to `false` to disable the GitHub Issues features on the repository. | `bool` | `true` | no |
| has\_projects | Set  to `true` to enable the GitHub Projects features on the repository. | `bool` | `false` | no |
| has\_wiki | Set  to `true` to enable the GitHub Wiki features on the repository. | `bool` | `false` | no |
| homepage\_url | URL of a page describing the project. | `string` | `""` | no |
| issue\_labels | List of issue labels on the repository. | <pre>list(object({<br>    name        = string<br>    color       = string<br>    description = string<br>  }))</pre> | `[]` | no |
| license\_template | Meaningful only during create, will be ignored after repository creation. Use the name of the template without the extension. For example, "Terraform". | `string` | `""` | no |
| tags | Additional tags (e.g. `map('BusinessUnit','XYZ')`) | `map(string)` | `{}` | no |
| teams | List of teams on the repository. | <pre>list(object({<br>    name       = string<br>    permission = string<br>  }))</pre> | `[]` | no |
| topics | A list of topics to add to the repository. | `list(string)` | `[]` | no |
| use\_fullname | Set 'true' to use `namespace-stage-name` for ecr repository name, else `name` | `bool` | `true` | no |
| visibility | Set to `public` to create a public (e.g. open source) repository. | `string` | `"private"` | no |

## Outputs

| Name | Description |
|------|-------------|
| default\_branch | The name of the default branch of the repository. |
| full\_name | A string of the form "orgname/reponame". |
| git\_clone\_url | URL that can be provided to "git clone" to clone the repository anonymously via the git protocol. |
| html\_url | URL to the repository on the web. |
| http\_clone\_url | URL that can be provided to "git clone" to clone the repository via HTTPS. |
| name | The name of the repository. |
| ssh\_clone\_url | URL that can be provided to "git clone" to clone the repository via SSH. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## License

[MIT](LICENSE)

Copyright (c) 2018 [Flaconi GmbH](https://github.com/Flaconi)
