locals {
  network_identity = {
    owner     = "tech4life"
    workspace = "chatapp"
    iteration = 1
  }
  project_name        = "chatapp"
  name_prefix         = "tech4life-${local.project_name}"
  name_suffix         = "dev01"
  resource_group_name = "${local.name_prefix}-rg-${local.name_suffix}"
  location            = "eastus2"
  aisearch_location   = "eastus"

  foundry_role_assignments = {
    "owners" = {
      role_definition_name = "Foundry Owner"
      principal_id         = data.azurerm_client_config.current.object_id
    }
  }

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

  tags = {
    owner       = "tech4life"
    environment = terraform.workspace
  }
}
