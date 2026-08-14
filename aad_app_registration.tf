resource "random_uuid" "ids" {}

resource "azuread_application" "expapi" {
  provider = azuread.external_tenant

  display_name     = local.expapi_app_registration_name
  description      = "Backend API for the Foundry chat experience."
  sign_in_audience = "AzureADMyOrg"
  identifier_uris  = [local.expapi_identifier_uri]

  api {
    requested_access_token_version = 2

    oauth2_permission_scope {
      admin_consent_description  = "Allows the app to read and write chat messages"
      admin_consent_display_name = "Read and write chat messages"
      enabled                    = true
      id                         = random_uuid.ids.result
      type                       = "User"
      user_consent_description   = "Allows the app to read and write your chat messages"
      user_consent_display_name  = "Read and write chat messages"
      value                      = local.expapi_scope_name
    }
  }
}

resource "azuread_application" "spa" {
  provider = azuread.external_tenant

  display_name     = local.spa_app_registration_name
  description      = "Browser-based client for the Foundry chat experience."
  sign_in_audience = "AzureADMyOrg"

  api {
    requested_access_token_version = 2
  }

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
