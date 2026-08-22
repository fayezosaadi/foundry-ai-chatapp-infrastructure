module "metadata" {
  source      = "git::https://github.com/fayezosaadi/techforlife-azure-terraform-labels.git?ref=06fe850743d945f5c10494dcdf5d1961300b10d3"
  environment = local.environment
}

resource "azurerm_resource_group" "rg" {
  name     = local.rg_name
  location = local.location

  tags = merge(module.metadata.tags, { what_is_this = "ChatApp Infrastructure Resource Group" })
}

resource "azurerm_container_app_environment" "acae" {
  name                = local.acae_name
  location            = local.location
  resource_group_name = local.rg_name
  tags                = merge(module.metadata.tags, { what_is_this = "ChatApp Infrastructure Container App Environment" })
}
