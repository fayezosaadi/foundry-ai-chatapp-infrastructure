# foundry-ai-chatapp-infrastructure

Terraform for the shared Azure + Microsoft Entra External ID foundation behind the chat app.

## What this repo manages

- Azure resource group and Foundry-related infrastructure
- External ID app registration for the future SPA
- External ID app registration for the future backend API
- Backend `Chat.ReadWrite` delegated scope
- SPA permission to request that backend scope
- Outputs the future `frontend-spa` and `backend-expapi` repos can consume

## What this repo does **not** manage

These still need to be created in the External ID tenant:

- customer tenant itself
- sign-up/sign-in user flow
- social, phone, or email identity providers
- branding, custom domain, MFA, custom sign-up attributes

## Auth model

This repo is set up for **public internet users**:

1. users authenticate with **Microsoft Entra External ID**
2. the SPA requests `Chat.ReadWrite` from the backend API
3. the backend validates External ID tokens
4. the backend calls Azure AI Foundry with **its own identity**, not user OBO

## Config files

### Committed shared config

`vars/dev.tfvars`

This file currently holds non-secret tenant-specific values such as:

- `external_id_tenant_id`
- `external_id_tenant_subdomain`
- `foundry_owner_upns`

### GitHub secrets

The workflows expect:

- `AZURE_CLIENT_ID`
- `AZURE_SUBSCRIPTION_ID`
- `AZURE_TENANT_ID`
- `EXTERNAL_ID_CLIENT_ID`

`EXTERNAL_ID_CLIENT_ID` is only needed because the External ID tenant is managed with a **separate tenant-specific
GitHub OIDC app**.

## Main Terraform inputs

| Variable                                   | Purpose                                                       |
|--------------------------------------------|---------------------------------------------------------------|
| `external_id_tenant_id`                    | External ID tenant GUID                                       |
| `external_id_client_id`                    | Optional GitHub OIDC app client ID for the External ID tenant |
| `external_id_tenant_subdomain`             | External ID hosted sign-in subdomain                          |
| `external_id_custom_domain`                | Optional branded login domain                                 |
| `external_id_application_owner_object_ids` | Optional app-registration owners in the External ID tenant    |
| `foundry_owner_upns`                       | Users who should receive the Foundry Owner role               |
| `spa_redirect_uris`                        | Redirect URIs for the future SPA                              |
| `expapi_identifier_uri`                    | Optional override for the backend API audience URI            |

## Local usage

```bash
terraform init
terraform plan -var-file=vars/dev.tfvars
terraform apply -var-file=vars/dev.tfvars
```

For guest users in `foundry_owner_upns`, use the **Entra UPN** form, for example:

```text
name_example.com#EXT#@tenant.onmicrosoft.com
```

## GitHub Actions behavior

- `tf-plan-apply.yml` only runs when Terraform-related files change
- plan and apply both use the same repo-level Azure and External ID production identities
- apply uses the saved `tfplan` artifact from the plan job

## Outputs for future app repos

### `frontend_spa_auth_settings`

Use for the future SPA:

- `tenant_id`
- `client_id`
- `authority`
- `authority_host`
- `redirect_uris`
- `api_scope`

### `backend_expapi_auth_settings`

Use for the future backend:

- `tenant_id`
- `client_id`
- `authority`
- `authority_host`
- `audience`
- `accepted_scopes`
- `token_issuer`
- `upstream_access_model`

## Bootstrap checklist

Before internet users can actually sign up:

1. create the External ID customer tenant
2. enable at least one sign-in method, usually email/password first
3. create a sign-up/sign-in user flow
4. associate the SPA and API apps with that flow
5. later point the app repos at the Terraform outputs from this repo
