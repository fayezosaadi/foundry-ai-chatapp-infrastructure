module "foundry_agent_service" {
  source = "git::https://github.com/fayezosaadi/azure_foundry_standard_agent_service.git?ref=5535b34cc7d736898c187ba4d9037374a77e9e0a"

  resource_group   = azurerm_resource_group.rg
  network_identity = local.network_identity
  location         = local.location
  search_location  = local.search_location
  deployments      = local.deployments
  connections      = local.connections
  tags             = merge(module.metadata.tags, { what_is_this = "ChatApp Foundry Agent Service" })
}
