module "metadata" {
  source      = "git::https://github.com/fayezosaadi/techforlife-azure-terraform-labels.git?ref=06fe850743d945f5c10494dcdf5d1961300b10d3"
  environment = local.environment
}

resource "azurerm_resource_group" "rg" {
  name     = local.rg_name
  location = local.location

  tags = merge(module.metadata.tags, { what_is_this = "ChatApp Infrastructure Resource Group" })
}

module "foundry_standard_agent_service" {
  source = "git::https://github.com/fayezosaadi/azure_foundry_standard_agent_service.git?ref=0a0da59ca27c1a87f1a6b74a255ca845b8dac5e2"

  resource_group   = azurerm_resource_group.rg
  location         = local.location
  search_location  = local.aisearch_location
  network_identity = local.network_identity
  deployments      = local.deployments
  tags             = module.metadata.tags
}
