terraform {
  required_version = ">= 0.15"
  required_providers {
    github = {
      source  = "integrations/github"
      version = ">= 5.16.0"
    }
  }
}
