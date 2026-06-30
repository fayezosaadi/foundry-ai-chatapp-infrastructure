output "frontend_spa_auth_settings" {
  description = "Configuration the future frontend-spa repo should consume for Entra External ID MSAL and API scope requests."
  value = {
    api_scope                      = "${local.expapi_identifier_uri}/${local.expapi_scope_name}"
    authority                      = local.external_id_authority_url
    authority_host                 = local.external_id_authority_host
    client_id                      = azuread_application.spa.client_id
    identity_provider              = "microsoft_entra_external_id"
    redirect_uris                  = local.normalized_spa_redirect_uris
    tenant_id                      = local.external_id_effective_tenant_id
    user_flow_association_required = true
  }
}

output "backend_expapi_auth_settings" {
  description = "Configuration the future backend-expapi repo should consume for Entra External ID token validation and app-owned upstream access."
  value = {
    accepted_scopes                = [local.expapi_scope_name]
    audience                       = local.expapi_identifier_uri
    authority                      = local.external_id_authority_url
    authority_host                 = local.external_id_authority_host
    client_id                      = azuread_application.expapi.client_id
    identity_provider              = "microsoft_entra_external_id"
    tenant_id                      = local.external_id_effective_tenant_id
    token_issuer                   = local.external_id_effective_tenant_id != null ? "https://${local.external_id_effective_tenant_id}.ciamlogin.com/${local.external_id_effective_tenant_id}/v2.0" : null
    upstream_access_model          = "backend_managed_identity"
    user_flow_association_required = true
  }
}

output "entra_app_registration_names" {
  description = "Display names of the Terraform-managed Entra External ID app registrations owned by this infrastructure repo."
  value = {
    expapi = azuread_application.expapi.display_name
    spa    = azuread_application.spa.display_name
  }
}

output "customer_identity_manual_prerequisites" {
  description = "External ID capabilities that must still be configured outside plain Terraform before internet users can sign up."
  value = [
    "Create or choose a Microsoft Entra External ID customer tenant and authenticate the azuread.external provider to it.",
    "Set external_id_tenant_subdomain or external_id_custom_domain so authority outputs resolve to a real hosted sign-in endpoint.",
    "Create a sign-up and sign-in user flow in the customer tenant, then associate the SPA/API apps to that flow.",
    "Enable the desired identity providers in the customer tenant, such as email-password, Google, or phone.",
    "Configure branding, custom domains, MFA, and any custom sign-up attributes in the customer tenant."
  ]
}
