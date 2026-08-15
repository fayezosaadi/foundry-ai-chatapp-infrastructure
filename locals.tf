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
