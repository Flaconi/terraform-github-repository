terraform {
  experiments      = [module_variable_optional_attrs]
  required_version = ">= 0.14"
  required_providers {
    github = {
      source  = "integrations/github"
      version = ">= 4.19.2"
    }
  }
}
