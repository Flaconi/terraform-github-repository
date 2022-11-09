# GitHub Repository Module

[![lint](https://github.com/flaconi/terraform-github-repository/workflows/linting/badge.svg?branch=master)](https://github.com/flaconi/terraform-github-repository/actions?query=workflow%3Alinting)
[![test](https://github.com/flaconi/terraform-github-repository/workflows/testing/badge.svg)](https://github.com/flaconi/terraform-github-repository/actions?query=workflow%3Atesting)
[![Tag](https://img.shields.io/github/tag/Flaconi/terraform-github-repository.svg)](https://github.com/Flaconi/terraform-github-repository/releases)
[![Terraform](https://img.shields.io/badge/Terraform--registry-github--repository-brightgreen.svg)](https://registry.terraform.io/modules/Flaconi/repository/github/)
[![license](http://img.shields.io/badge/license-MIT-brightgreen.svg)](http://opensource.org/licenses/MIT)

This Terraform module manages GitHub repositories. 
Initially it was a backport from https://github.com/innovationnorway/terraform-github-repository which was written for `0.12` and as dynamic blocks were removed to be complied with `0.11`.

## Important notice

:warning: This module uses experimental optional attributes.

More about it [here](https://www.terraform.io/language/expressions/type-constraints#experimental-optional-object-type-attributes).

## Example Usage

### Create private repository

```hcl
module "my_pets_website_repo" {
  source = "github.com/flaconi/terraform-github-repository.git?ref=master"

  name        = "my-pets-website"
  description = "My pets codebase."
  visibility  = "private"

  gitignore_template = "Node"

  default_branch_protection_enabled = false
}
```

### Create public (e.g. open source) repository

```hcl
module "terraform_my_pets_repo" {
  source  = "github.com/flaconi/terraform-github-repository.git?ref=master"

  namespace   = "terraform"
  tenant      = "my"
  name        = "pets"
  description = "Terraform configuration for my pets."
  visibility  = "public"

  gitignore_template = "Terraform"
  license_template   = "mit"
}
```

### Add collaborators and teams

```hcl
data "github_team" "developers" {
  slug = "developers"
}

module "example_repo" {
  source  = "github.com/flaconi/terraform-github-repository.git?ref=master"

  name        = "example"
  description = "My example codebase"

  visibility = "private"

  teams = [
    {
      name      = "security"
      permisson = "admin"
    },
    {
      # Specify Team ID to use external data source
      id        = data.github_team.developers.id
      name      = "developers"
      permisson = "push"
    }
  ]
}
```

### Set branch protection options

```hcl
module "example_repo" {
  source  = "github.com/flaconi/terraform-github-repository.git?ref=master"

  name        = "example"
  description = "My example codebase"

  visibility = "private"
  
  # Overwrite some settings for default branch
  default_branch_protection = {
    required_status_checks = {
      contexts = ["ci/travis"]
    }
    required_pull_request_reviews = {
      dismiss_stale_reviews  = true
      dismissal_restrictions = ["team1","team2"]
    }
  }
}
```

### Add issue labels

```hcl
module "example_repo" {
  source  = "github.com/flaconi/terraform-github-repository.git?ref=master"

  name        = "example"
  description = "My example codebase"

  visibility = "private"

  default_branch_protection_enabled = false

  issue_labels = [
    {
      name        = "bug"
      color       = "d73a4a"
      description = "This is a bug."
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
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.15 |
| <a name="requirement_github"></a> [github](#requirement\_github) | >= 4.26.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_github"></a> [github](#provider\_github) | >= 4.26.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_label"></a> [label](#module\_label) | github.com/cloudposse/terraform-null-label.git | 0.25.0 |

## Resources

| Name | Type |
|------|------|
| [github_actions_environment_secret.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_environment_secret) | resource |
| [github_actions_secret.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/actions_secret) | resource |
| [github_branch_protection.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/branch_protection) | resource |
| [github_dependabot_secret.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/dependabot_secret) | resource |
| [github_issue_label.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/issue_label) | resource |
| [github_repository.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository) | resource |
| [github_repository_collaborator.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_collaborator) | resource |
| [github_repository_deploy_key.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_deploy_key) | resource |
| [github_repository_environment.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_environment) | resource |
| [github_repository_webhook.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/repository_webhook) | resource |
| [github_team_repository.this](https://registry.terraform.io/providers/integrations/github/latest/docs/resources/team_repository) | resource |
| [github_team.this](https://registry.terraform.io/providers/integrations/github/latest/docs/data-sources/team) | data source |

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
| <a name="input_bot_secrets"></a> [bot\_secrets](#input\_bot\_secrets) | Repository dependabot secrets. | <pre>map(object({<br>    encrypted_value = optional(string)<br>    plaintext_value = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_branch_protection"></a> [branch\_protection](#input\_branch\_protection) | Branch protection settings. Use to set protection rules for branches different to default branch. | <pre>map(object({<br>    enforce_admins                  = optional(bool)<br>    allows_deletions                = optional(bool)<br>    allows_force_pushes             = optional(bool)<br>    require_signed_commits          = optional(bool)<br>    required_linear_history         = optional(bool)<br>    require_conversation_resolution = optional(bool)<br>    push_restrictions               = optional(list(string))<br>    required_status_enabled         = optional(bool)<br>    required_status_checks = optional(object({<br>      strict   = optional(bool)<br>      contexts = optional(list(string))<br>    }))<br>    required_pull_request_enabled = optional(bool)<br>    required_pull_request_reviews = optional(object({<br>      dismiss_stale_reviews           = optional(bool)<br>      restrict_dismissals             = optional(bool)<br>      dismissal_restrictions          = optional(list(string))<br>      require_code_owner_reviews      = optional(bool)<br>      required_approving_review_count = optional(number)<br>    }))<br>  }))</pre> | `null` | no |
| <a name="input_collaborators"></a> [collaborators](#input\_collaborators) | Map of users with permissions. | `map(string)` | `{}` | no |
| <a name="input_default_branch_protection"></a> [default\_branch\_protection](#input\_default\_branch\_protection) | Default branch protection settings. | <pre>object({<br>    enforce_admins                  = optional(bool)<br>    allows_deletions                = optional(bool)<br>    allows_force_pushes             = optional(bool)<br>    require_signed_commits          = optional(bool)<br>    required_linear_history         = optional(bool)<br>    require_conversation_resolution = optional(bool)<br>    push_restrictions               = optional(list(string))<br>    required_status_enabled         = optional(bool)<br>    required_status_checks = optional(object({<br>      strict   = optional(bool)<br>      contexts = optional(list(string))<br>    }))<br>    required_pull_request_enabled = optional(bool)<br>    required_pull_request_reviews = optional(object({<br>      dismiss_stale_reviews           = optional(bool)<br>      restrict_dismissals             = optional(bool)<br>      dismissal_restrictions          = optional(list(string))<br>      require_code_owner_reviews      = optional(bool)<br>      required_approving_review_count = optional(number)<br>    }))<br>  })</pre> | `{}` | no |
| <a name="input_default_branch_protection_enabled"></a> [default\_branch\_protection\_enabled](#input\_default\_branch\_protection\_enabled) | Set to `false` if you want to disable branch protection for default branch | `bool` | `true` | no |
| <a name="input_delete_branch_on_merge"></a> [delete\_branch\_on\_merge](#input\_delete\_branch\_on\_merge) | Automatically delete head branch after a pull request is merged. | `bool` | `true` | no |
| <a name="input_delimiter"></a> [delimiter](#input\_delimiter) | Delimiter to be used between `name`, `namespace`, `tenant`, etc. | `string` | `"-"` | no |
| <a name="input_deploy_keys"></a> [deploy\_keys](#input\_deploy\_keys) | List of deploy keys configurations. | <pre>list(object({<br>    title     = string<br>    key       = string<br>    read_only = bool<br>  }))</pre> | `[]` | no |
| <a name="input_description"></a> [description](#input\_description) | A description of the repository. | `string` | `""` | no |
| <a name="input_environments"></a> [environments](#input\_environments) | Repository environments. | <pre>map(object({<br>    reviewers = optional(object({<br>      teams = optional(list(string))<br>      users = optional(list(string))<br>    }))<br>    branch_policy = optional(object({<br>      protected_branches     = optional(bool)<br>      custom_branch_policies = optional(bool)<br>    }))<br>    secrets = optional(map(object({<br>      encrypted_value = optional(string)<br>      plaintext_value = optional(string)<br>    })))<br>  }))</pre> | `{}` | no |
| <a name="input_gitignore_template"></a> [gitignore\_template](#input\_gitignore\_template) | Meaningful only during create, will be ignored after repository creation. Use the name of the template without the extension. For example, "Terraform". | `string` | `""` | no |
| <a name="input_has_downloads"></a> [has\_downloads](#input\_has\_downloads) | Set to `true` to enable the (deprecated) downloads features on the repository. | `bool` | `null` | no |
| <a name="input_has_issues"></a> [has\_issues](#input\_has\_issues) | Set  to `false` to disable the GitHub Issues features on the repository. | `bool` | `true` | no |
| <a name="input_has_projects"></a> [has\_projects](#input\_has\_projects) | Set  to `true` to enable the GitHub Projects features on the repository. | `bool` | `false` | no |
| <a name="input_has_wiki"></a> [has\_wiki](#input\_has\_wiki) | Set  to `true` to enable the GitHub Wiki features on the repository. | `bool` | `false` | no |
| <a name="input_homepage_url"></a> [homepage\_url](#input\_homepage\_url) | URL of a page describing the project. | `string` | `""` | no |
| <a name="input_is_template"></a> [is\_template](#input\_is\_template) | Set to `true` to tell GitHub that this is a template repository. | `bool` | `false` | no |
| <a name="input_issue_labels"></a> [issue\_labels](#input\_issue\_labels) | List of issue labels on the repository. | <pre>list(object({<br>    name        = string<br>    color       = string<br>    description = string<br>  }))</pre> | `[]` | no |
| <a name="input_license_template"></a> [license\_template](#input\_license\_template) | Meaningful only during create, will be ignored after repository creation. Use the name of the template without the extension. For example, "Terraform". | `string` | `""` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Namespace, e.g. `terraform`, `product`, `mobile` etc. | `string` | `null` | no |
| <a name="input_pages"></a> [pages](#input\_pages) | The repository's GitHub Pages configuration. | <pre>object({<br>    source = object({<br>      branch = string<br>      path   = string<br>    })<br>  })</pre> | `null` | no |
| <a name="input_secrets"></a> [secrets](#input\_secrets) | Repository secrets. | <pre>map(object({<br>    encrypted_value = optional(string)<br>    plaintext_value = optional(string)<br>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags (e.g. `map('BusinessUnit','XYZ')`) | `map(string)` | `{}` | no |
| <a name="input_teams"></a> [teams](#input\_teams) | List of teams with permissions. Specify Team ID to avoid additional requests to GitHub API. | <pre>list(object({<br>    id         = optional(string)<br>    name       = string<br>    permission = string<br>  }))</pre> | `[]` | no |
| <a name="input_template"></a> [template](#input\_template) | Use a template repository to create this repository. | <pre>object({<br>    owner      = string<br>    repository = string<br>  })</pre> | `null` | no |
| <a name="input_tenant"></a> [tenant](#input\_tenant) | A customer identifier, indicating who this instance of a resource is for. Could be used for application grouping. | `string` | `null` | no |
| <a name="input_topics"></a> [topics](#input\_topics) | A list of topics to add to the repository. | `list(string)` | `[]` | no |
| <a name="input_use_fullname"></a> [use\_fullname](#input\_use\_fullname) | Set 'true' to use `namespace-tenant-name` for github repository name, else `name` | `bool` | `true` | no |
| <a name="input_visibility"></a> [visibility](#input\_visibility) | Set to `public` to create a public (e.g. open source) repository. | `string` | `"private"` | no |
| <a name="input_vulnerability_alerts"></a> [vulnerability\_alerts](#input\_vulnerability\_alerts) | Set to `true` to enable security alerts for vulnerable dependencies. Enabling requires alerts to be enabled on the owner level. | `bool` | `false` | no |
| <a name="input_webhooks"></a> [webhooks](#input\_webhooks) | List of webhook configurations. | <pre>list(object({<br>    ident  = string # some unique string to identify this webhook<br>    active = optional(bool)<br>    events = list(string)<br>    configuration = object({<br>      url          = string<br>      content_type = string<br>      secret       = optional(string)<br>      insecure_ssl = optional(bool)<br>    })<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dependabot_secrets"></a> [dependabot\_secrets](#output\_dependabot\_secrets) | A map of dependabot secret names |
| <a name="output_environments"></a> [environments](#output\_environments) | A list of created environments |
| <a name="output_environments_secrets"></a> [environments\_secrets](#output\_environments\_secrets) | A map of environment secret names |
| <a name="output_repository"></a> [repository](#output\_repository) | Created repository |
| <a name="output_repository_branch_protection"></a> [repository\_branch\_protection](#output\_repository\_branch\_protection) | Default branch protection settings |
| <a name="output_repository_secrets"></a> [repository\_secrets](#output\_repository\_secrets) | A map of create secret names |
| <a name="output_repository_webhook_urls"></a> [repository\_webhook\_urls](#output\_repository\_webhook\_urls) | Webhook URLs |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## License

[MIT](LICENSE)

Copyright (c) 2019-2022 [Flaconi GmbH](https://github.com/Flaconi)
