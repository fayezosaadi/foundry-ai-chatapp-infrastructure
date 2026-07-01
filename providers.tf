provider "azurerm" {
  features {}
  storage_use_azuread = true
  use_oidc            = true
}

provider "azuread" {}

provider "azuread" {
  alias     = "external"
  client_id = var.external_id_client_id
  tenant_id = var.external_id_tenant_id
}
