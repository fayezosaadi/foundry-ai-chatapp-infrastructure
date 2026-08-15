module "foundry_agent_service" {
  source = "git::https://github.com/fayezosaadi/azure_foundry_standard_agent_service.git?ref=30917051198be6230183c69f454b42a71d8fa153"

  resource_group   = azurerm_resource_group.rg
  network_identity = local.network_identity
  location         = local.location
  search_location  = local.search_location
  deployments      = local.deployments
  tags             = merge(module.metadata.tags, { what_is_this = "ChatApp Foundry Agent Service" })
}
