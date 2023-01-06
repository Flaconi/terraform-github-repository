terraform {
  experiments      = [module_variable_optional_attrs]
  required_version = ">= 0.15"
  required_providers {
    github = {
      source  = "integrations/github"
      version = ">= 5.13.0"
    }
  }
}
