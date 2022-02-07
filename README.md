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

  default_branch_protection_dismissal_teams = ["team1","team2"]
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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_github"></a> [github](#requirement\_github) | >= 4.19.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_github"></a> [github](#provider\_github) | >= 4.19.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_label"></a> [label](#module\_label) | github.com/cloudposse/terraform-null-label.git | 0.25.0 |

## Resources

| Name | Type |
|------|------|
| [github_branch_protection.main](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch_protection) | resource |
| [github_issue_label.main](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/issue_label) | resource |
| [github_repository.main](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository) | resource |
| [github_repository_collaborator.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_collaborator) | resource |
| [github_team_repository.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/team_repository) | resource |
| [github_team.main](https://registry.terraform.io/providers/integrations/github/latest/docs/data-sources/team) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | The name of the repository. | `string` | n/a | yes |
| <a name="input_allow_auto_merge"></a> [allow\_auto\_merge](#input\_allow\_auto\_merge) | Set to `true` to allow auto-merging pull requests on the repository. | `bool` | `false` | no |
| <a name="input_allow_merge_commit"></a> [allow\_merge\_commit](#input\_allow\_merge\_commit) | Set  to `false` to disable merge commits on the repository. | `bool` | `false` | no |
| <a name="input_allow_rebase_merge"></a> [allow\_rebase\_merge](#input\_allow\_rebase\_merge) | Set  to `false` to disable rebase merges on the repository. | `bool` | `false` | no |
| <a name="input_allow_squash_merge"></a> [allow\_squash\_merge](#input\_allow\_squash\_merge) | Set  to `false` to disable squash merges on the repository. | `bool` | `true` | no |
| <a name="input_archive_on_destroy"></a> [archive\_on\_destroy](#input\_archive\_on\_destroy) | Set to `true` to archive the repository instead of deleting on destroy. | `bool` | `false` | no |
| <a name="input_archived"></a> [archived](#input\_archived) | Specifies if the repository should be archived. | `bool` | `false` | no |
| <a name="input_attributes"></a> [attributes](#input\_attributes) | Additional attributes (e.g. `policy` or `role`) | `list(string)` | `[]` | no |
| <a name="input_auto_init"></a> [auto\_init](#input\_auto\_init) | Meaningful only during create; set  to `true` to produce an initial commit in the repository. | `bool` | `true` | no |
| <a name="input_collaborators"></a> [collaborators](#input\_collaborators) | Map of users with permissions. | `map(string)` | `{}` | no |
| <a name="input_default_branch"></a> [default\_branch](#input\_default\_branch) | The name of the default branch of the repository. | `string` | `"master"` | no |
| <a name="input_default_branch_protection_dismiss_stale_reviews"></a> [default\_branch\_protection\_dismiss\_stale\_reviews](#input\_default\_branch\_protection\_dismiss\_stale\_reviews) | Dismiss approved reviews automatically when a new commit is pushed. Defaults to false. | `bool` | `true` | no |
| <a name="input_default_branch_protection_enabled"></a> [default\_branch\_protection\_enabled](#input\_default\_branch\_protection\_enabled) | Do we want to enable branch protection for the default branch | `bool` | `false` | no |
| <a name="input_default_branch_protection_enforce_admins"></a> [default\_branch\_protection\_enforce\_admins](#input\_default\_branch\_protection\_enforce\_admins) | Boolean, setting this to true enforces status checks for repository administrators. | `bool` | `false` | no |
| <a name="input_default_branch_protection_require_code_owner_reviews"></a> [default\_branch\_protection\_require\_code\_owner\_reviews](#input\_default\_branch\_protection\_require\_code\_owner\_reviews) | Require an approved review in pull requests including files with a designated code owner. Defaults to false. | `bool` | `false` | no |
| <a name="input_default_branch_protection_required_status_checks_contexts"></a> [default\_branch\_protection\_required\_status\_checks\_contexts](#input\_default\_branch\_protection\_required\_status\_checks\_contexts) | List of status checks, e.g. travis | `list(string)` | `[]` | no |
| <a name="input_default_branch_protection_required_status_checks_strict"></a> [default\_branch\_protection\_required\_status\_checks\_strict](#input\_default\_branch\_protection\_required\_status\_checks\_strict) | Require branches to be up to date before merging. Defaults to false. | `bool` | `true` | no |
| <a name="input_default_branch_protection_restrictions_teams"></a> [default\_branch\_protection\_restrictions\_teams](#input\_default\_branch\_protection\_restrictions\_teams) | The list of team slugs with push access. Always use slug of the team, not its name. Each team already has to have access to the repository. | `list(string)` | `[]` | no |
| <a name="input_delete_branch_on_merge"></a> [delete\_branch\_on\_merge](#input\_delete\_branch\_on\_merge) | Automatically delete head branch after a pull request is merged. | `bool` | `true` | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between `name`, `namespace`, `tenant`, etc. | `string` | `"-"` | no |
| <a name="input_description"></a> [description](#input\_description) | A description of the repository. | `string` | `""` | no |
| <a name="input_gitignore_template"></a> [gitignore\_template](#input\_gitignore\_template) | Meaningful only during create, will be ignored after repository creation. Use the name of the template without the extension. For example, "Terraform". | `string` | `""` | no |
| <a name="input_has_issues"></a> [has\_issues](#input\_has\_issues) | Set  to `false` to disable the GitHub Issues features on the repository. | `bool` | `true` | no |
| <a name="input_has_projects"></a> [has\_projects](#input\_has\_projects) | Set  to `true` to enable the GitHub Projects features on the repository. | `bool` | `false` | no |
| <a name="input_has_wiki"></a> [has\_wiki](#input\_has\_wiki) | Set  to `true` to enable the GitHub Wiki features on the repository. | `bool` | `false` | no |
| <a name="input_homepage_url"></a> [homepage\_url](#input\_homepage\_url) | URL of a page describing the project. | `string` | `""` | no |
| <a name="input_is_template"></a> [is\_template](#input\_is\_template) | Set to `true` to tell GitHub that this is a template repository. | `bool` | `false` | no |
| <a name="input_issue_labels"></a> [issue\_labels](#input\_issue\_labels) | List of issue labels on the repository. | <pre>list(object({<br>    name        = string<br>    color       = string<br>    description = string<br>  }))</pre> | `[]` | no |
| <a name="input_license_template"></a> [license\_template](#input\_license\_template) | Meaningful only during create, will be ignored after repository creation. Use the name of the template without the extension. For example, "Terraform". | `string` | `""` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace, e.g. `terraform`, `product`, `mobile` etc. | `string` | `null` | no |
| <a name="input_pages"></a> [pages](#input\_pages) | The repository's GitHub Pages configuration. | <pre>object({<br>    source = object({<br>      branch = string<br>      path   = string<br>    })<br>  })</pre> | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `map('BusinessUnit','XYZ')`) | `map(string)` | `{}` | no |
| <a name="input_teams"></a> [teams](#input\_teams) | Map of organization teams with permissions. | `map(string)` | `{}` | no |
| <a name="input_template"></a> [template](#input\_template) | Use a template repository to create this repository. | <pre>object({<br>    owner      = string<br>    repository = string<br>  })</pre> | `null` | no |
| <a name="input_tenant"></a> [tenant](#input\_tenant) | A customer identifier, indicating who this instance of a resource is for. Could be used for application grouping. | `string` | `null` | no |
| <a name="input_topics"></a> [topics](#input\_topics) | A list of topics to add to the repository. | `list(string)` | `[]` | no |
| <a name="input_use_fullname"></a> [use\_fullname](#input\_use\_fullname) | Set 'true' to use `namespace-tenant-name` for github repository name, else `name` | `bool` | `true` | no |
| <a name="input_visibility"></a> [visibility](#input\_visibility) | Set to `public` to create a public (e.g. open source) repository. | `string` | `"private"` | no |
| <a name="input_vulnerability_alerts"></a> [vulnerability\_alerts](#input\_vulnerability\_alerts) | Set to `true` to enable security alerts for vulnerable dependencies. Enabling requires alerts to be enabled on the owner level. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_repository"></a> [repository](#output\_repository) | Created repository |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## License

[MIT](LICENSE)

Copyright (c) 2021 [Flaconi GmbH](https://github.com/Flaconi)
