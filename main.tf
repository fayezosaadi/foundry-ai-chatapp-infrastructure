resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = local.location

  tags = merge(local.tags, { what_is_this = "Foundry Resource Group" })
}

module "foundry_standard_agent_service" {
  source = "git::ssh://git@github.com/fayezosaadi/azure_foundry_standard_agent_service.git?ref=v0.0.1"

  resource_group   = azurerm_resource_group.rg
  location         = local.location
  search_location  = local.aisearch_location
  network_identity = local.network_identity
  deployments      = local.deployments
  role_assignments = local.foundry_role_assignments

  tags = local.tags
}
