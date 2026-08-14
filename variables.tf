variable "external_client_id" {
  description = "The Application ID for the external tenant OIDC app registration"
  type    = string
  default = null
}

variable "external_tenant_id" {
  description = "The Directory ID of the external tenant"
  type    = string
  default = null
}

variable "backend_api_display_name" {
  description = "Friendly display name for the backend API app registration."
  type        = string
  default     = "Foundry Chat API"
}

variable "expapi_identifier_uri" {
  description = "Optional identifier URI override for the future backend-expapi registration. When null, a stable repo-owned api:// URI is used."
  type        = string
  default     = null
  nullable    = true
}

variable "frontend_web_display_name" {
  description = "Friendly display name for the browser-based frontend app registration."
  type        = string
  default     = "Foundry Chat App"
}

variable "spa_redirect_uris" {
  description = "Redirect URIs allowed for the browser-based frontend registration. Keep localhost for local dev and add deployed web origins as they exist."
  type        = list(string)
  default     = ["http://localhost:5173"]
}
