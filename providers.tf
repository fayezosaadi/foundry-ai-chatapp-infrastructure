provider "azurerm" {
  features {}
  use_oidc = true
}

provider "azuread" {
  alias    = "external_tenant"
  use_oidc = true

  client_id = var.external_client_id
  tenant_id = var.external_tenant_id
}
