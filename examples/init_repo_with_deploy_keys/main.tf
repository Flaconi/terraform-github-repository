variable "token" {
  type    = string
  default = ""
}

variable "owner" {
  type    = string
  default = ""
}

# This will create `terraform-example-test-webhooks` repository
module "example" {
  source = "../../"

  token = var.token
  owner = var.owner

  namespace   = "terraform"
  tenant      = "example"
  name        = "test-deploy-keys"
  description = "Terraform module example github repository"

  visibility = "private"

  gitignore_template = "Terraform"
  license_template   = "mit"

  vulnerability_alerts = true

  default_branch_protection_enabled = false

  deploy_keys = [
    {
      title     = "read-only"
      key       = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAgQCnxrhTA8hy5xje/++8BfvbhuKYCWD9FZqNs99BXkur/2GOOw8JX3ClRPnxmFSP3wUekarv0FgIiPrUhE4g4ea1CCoqC3HhZmfoG+VsvjhJnn+LjhcVIh6MvlQ42ZixJCdH3vmLm13BVZMzFfhW1v6pYfm3hkjU7UQvMHUGiLEpvw=="
      read_only = true
    },
    {
      title     = "read-write"
      key       = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAAAgQCeYlgKyoZbD38AXI6qTEgZhTsULQ65WNl2YjrAYR3Rp2DtQhuOOyGTp3caw4ukMnt3B0+5nQuinsmzgUyK4PShAioX/vz9h2qpCY0Rpv3zWfb/qV/SmMr/iN5pDxSqaWx6ScAXPalTfwvSk8DSG0eDR+JSh4elT+Sq1bQQ+32dzw=="
      read_only = false
    }
  ]
}

output "repository" {
  value = module.example.repository
}
