locals {
  environment_map = {
    "prod"    = "prd"
    "default" = "prd"
  }

  network_identity = {
    workspace = "chatapp"
    iteration = "1"
  }

  workspace       = lower(local.network_identity.workspace)
  environment     = local.environment_map[terraform.workspace]
  name_suffix     = "${local.environment}${local.network_identity.iteration}"
  rg_name         = "rg-${local.workspace}-${local.name_suffix}"
  location        = "eastus2"
  search_location = "eastus"
  acae_name       = "acae-${local.workspace}-${local.name_suffix}"

  # Shared RG
  shared_workspace         = "shared"
  shared_rg_name           = "rg-${local.shared_workspace}-${local.name_suffix}"
  shared_app_insights_name = "appinsights-${local.shared_workspace}-${local.name_suffix}"

  # Foundry
  deployments = {
    "gpt-4.1" = {
      model = {
        name    = "gpt-4.1"
        version = "2025-04-14"
        format  = "OpenAI"
      }
      "text-embedding-3-large" = {
        name    = "text-embedding-3-large"
        version = "1"
        format  = "OpenAI"
      }
      sku = {
        name     = "GlobalStandard"
        capacity = 100
      }
    }
  }

  connections = {
    (data.azurerm_application_insights.app_insights.name) = {
      category = "AppInsights"
      target   = data.azurerm_application_insights.app_insights.id
      authType = "ApiKey"
      credentials = {
        key = data.azurerm_application_insights.app_insights.connection_string
      }
      metadata = {
        ApiType    = "Azure"
        ResourceId = data.azurerm_application_insights.app_insights.id
        location   = data.azurerm_application_insights.app_insights.location
      }
    }
  }

  # App Registration

  # ExpApi
  expapi_app_registration_name = var.backend_api_display_name
  expapi_identifier_uri_slug   = replace(lower(local.expapi_app_registration_name), "/[^0-9a-z._-]/", "-")
  expapi_identifier_uri        = coalesce(var.expapi_identifier_uri, "api://${local.expapi_identifier_uri_slug}")
  expapi_scope_name            = "Chat.ReadWrite"

  # SPA
  spa_app_registration_name    = var.frontend_web_display_name
  normalized_spa_redirect_uris = [for uri in var.spa_redirect_uris : length(regexall("^https?://[^/]+$", uri)) > 0 ? "${uri}/" : uri]
}
