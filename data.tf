data "azurerm_client_config" "current" {}

data "azuread_client_config" "external" {
  provider = azuread.external
}

data "azuread_user" "foundry_owner_users" {
  for_each            = var.foundry_owner_upns
  user_principal_name = each.value
}
