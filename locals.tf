locals {
  network_identity = {
    owner     = "tech4life"
    workspace = "chatapp"
    iteration = 1
  }
  project_name        = "chatapp"
  name_prefix         = "tech4life-${local.project_name}"
  name_suffix         = "dev01"
  resource_group_name = "${local.name_prefix}-rg-${local.name_suffix}"
  location            = "eastus2"
  aisearch_location   = "eastus"

  foundry_owner_subjects = merge(
    {
      for upn, user in data.azuread_user.foundry_owner_users :
      "upn-${substr(sha1(upn), 0, 12)}" => {
        principal_id = user.object_id
      }
    },
    length(var.foundry_owner_upns) == 0 ? {
      "owners" = {
        principal_id = data.azurerm_client_config.current.object_id
      }
    } : {}
  )

  foundry_role_assignments = {
    for key, owner in local.foundry_owner_subjects :
    key => {
      role_definition_name = "Foundry Owner"
      principal_id         = owner.principal_id
    }
  }

  deployments = {
    "gpt-4.1" = {
      model = {
        name    = "gpt-4.1"
        version = "2025-04-14"
        format  = "OpenAI"
      }
      sku = {
        name     = "GlobalStandard"
        capacity = 100
      }
    }
  }

  # auth
  external_id_effective_tenant_id = coalesce(var.external_id_tenant_id, data.azurerm_client_config.current.tenant_id)
  external_id_authority_host = (
    var.external_id_custom_domain != null ? var.external_id_custom_domain :
    var.external_id_tenant_subdomain != null ? "${var.external_id_tenant_subdomain}.ciamlogin.com" :
    null
  )
  external_id_authority_url = local.external_id_authority_host != null ? "https://${local.external_id_authority_host}/" : null
  customer_identity_application_owner_object_ids = (
    var.external_id_application_owner_object_ids != null ?
    var.external_id_application_owner_object_ids :
    toset([data.azuread_client_config.external.object_id])
  )
  spa_app_registration_name    = "${local.name_prefix}-spa-${local.name_suffix}"
  expapi_app_registration_name = "${local.name_prefix}-expapi-${local.name_suffix}"
  expapi_identifier_uri        = coalesce(var.expapi_identifier_uri, "api://${local.expapi_app_registration_name}")
  expapi_scope_name            = "Chat.ReadWrite"
  normalized_spa_redirect_uris = [for uri in var.spa_redirect_uris : length(regexall("^https?://[^/]+$", uri)) > 0 ? "${uri}/" : uri]

  tags = {
    owner       = "tech4life"
    environment = terraform.workspace
  }
}
