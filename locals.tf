locals {
  environment_map = {
    "prod"    = "prd"
    "default" = "prd"
  }

  network_identity = {
    workspace = "chatapp"
    iteration = "1"
  }

  workspace         = lower(local.network_identity.workspace)
  environment       = local.environment_map[terraform.workspace]
  name_suffix       = "${local.environment}${local.network_identity.iteration}"
  rg_name           = "rg-${local.workspace}-${local.name_suffix}"
  location          = "eastus2"
  aisearch_location = "eastus"

  deployments = {
    "gpt-4.1" = {
      model = {
        name    = "gpt-4.1"
        version = "2025-04-14"
        format  = "OpenAI"
      }
      sku = {
        name     = "GlobalStandard"
        capacity = 100
      }
    }
  }
}
