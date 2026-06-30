variable "spa_redirect_uris" {
  description = "Redirect URIs allowed for the future frontend-spa registration. Keep localhost for local dev and add deployed origins as they exist."
  type        = list(string)
  default     = ["http://localhost:5173"]
}

variable "external_id_tenant_id" {
  description = "Customer tenant ID for Microsoft Entra External ID. The aliased azuread.external provider manages app registrations in this tenant."
  type        = string
  default     = null
  nullable    = true
}

variable "external_id_tenant_subdomain" {
  description = "Tenant subdomain used by Entra External ID hosted sign-in, e.g. contoso if the authority is https://contoso.ciamlogin.com/."
  type        = string
  default     = null
  nullable    = true
}

variable "external_id_custom_domain" {
  description = "Optional custom auth domain for Entra External ID, used instead of <subdomain>.ciamlogin.com when configured."
  type        = string
  default     = null
  nullable    = true
}

variable "external_id_application_owner_object_ids" {
  description = "Optional object IDs in the External ID tenant to assign as owners of the SPA/API app registrations. Defaults to the currently authenticated principal in that tenant."
  type        = set(string)
  default     = null
  nullable    = true
}

variable "foundry_owner_principal_id" {
  description = "Stable principal ID to keep the Foundry Owner role assignment from drifting based on which identity runs Terraform."
  type        = string
  default     = null
  nullable    = true
}

variable "expapi_identifier_uri" {
  description = "Optional identifier URI override for the future backend-expapi registration. When null, a stable repo-owned api:// URI is used."
  type        = string
  default     = null
  nullable    = true
}
