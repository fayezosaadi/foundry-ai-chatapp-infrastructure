resource "azuread_application" "spa" {
  provider = azuread.external

  display_name     = local.spa_app_registration_name
  owners           = local.customer_identity_application_owner_object_ids
  sign_in_audience = "AzureADMyOrg"

  single_page_application {
    redirect_uris = local.normalized_spa_redirect_uris
  }

  required_resource_access {
    resource_app_id = azuread_application.expapi.client_id

    resource_access {
      id   = azuread_application.expapi.oauth2_permission_scope_ids[local.expapi_scope_name]
      type = "Scope"
    }
  }
}

resource "azuread_service_principal" "spa" {
  provider = azuread.external

  client_id = azuread_application.spa.client_id
  owners    = local.customer_identity_application_owner_object_ids
}

resource "azuread_application" "expapi" {
  provider = azuread.external

  display_name     = local.expapi_app_registration_name
  owners           = local.customer_identity_application_owner_object_ids
  sign_in_audience = "AzureADMyOrg"
  identifier_uris  = [local.expapi_identifier_uri]

  api {
    requested_access_token_version = 2

    oauth2_permission_scope {
      admin_consent_description  = "Allows the app to read and write chat messages"
      admin_consent_display_name = "Read and write chat messages"
      enabled                    = true
      id                         = "84925bbd-0f1a-5c2a-af16-cd740e8ef7c8"
      type                       = "User"
      user_consent_description   = "Allows the app to read and write your chat messages"
      user_consent_display_name  = "Read and write chat messages"
      value                      = local.expapi_scope_name
    }
  }
}

resource "azuread_service_principal" "expapi" {
  provider = azuread.external

  client_id = azuread_application.expapi.client_id
  owners    = local.customer_identity_application_owner_object_ids
}

resource "azuread_service_principal_delegated_permission_grant" "spa_to_expapi" {
  provider = azuread.external

  service_principal_object_id          = azuread_service_principal.spa.object_id
  resource_service_principal_object_id = azuread_service_principal.expapi.object_id
  claim_values                         = [local.expapi_scope_name]
}
