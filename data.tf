data "azurerm_application_insights" "app_insights" {
  name                = local.shared_app_insights_name
  resource_group_name = local.shared_rg_name
}
