resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = local.location

  tags = merge(local.tags, { what_is_this = "Foundry Resource Group" })
}

module "foundry_standard_agent_service" {
  source = "git::https://github.com/fayezosaadi/azure_foundry_standard_agent_service.git?ref=2caa65e1db6798b5aa053ec2e8f9315496049153"

  resource_group   = azurerm_resource_group.rg
  location         = local.location
  search_location  = local.aisearch_location
  network_identity = local.network_identity
  deployments      = local.deployments
  role_assignments = local.foundry_role_assignments

  tags = local.tags
}
