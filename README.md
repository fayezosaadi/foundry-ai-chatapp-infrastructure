# foundry-ai-chatapp-infrastructure

This repo owns the shared Azure infrastructure for the chat app, including the Microsoft Entra External ID app registrations that future `backend-expapi` and `frontend-spa` repos will consume.

## What Terraform manages

- Azure resource group + Foundry resources
- Entra External ID SPA app registration for the future frontend
- Entra External ID API app registration for the future backend
- `Chat.ReadWrite` delegated scope exposed by the backend API
- SPA permission to request that backend scope
- Outputs for future SPA/API repos to validate tokens against Entra External ID

## What Terraform does **not** manage

These still need to be bootstrapped in the Entra admin center or separate automation:

- Creating the External ID customer tenant itself
- User flows / sign-up-sign-in journeys
- Social or phone identity providers
- Branding, custom auth domain, MFA, and custom sign-up attributes

## Default auth shape

Terraform creates two separate app registrations so the future repos stay decoupled:

| App registration | Purpose | Default local behavior |
| --- | --- | --- |
| `tech4life-chatapp-spa-dev01` | Browser client used by `frontend-spa` | Redirect URI `http://localhost:5173/` |
| `tech4life-chatapp-expapi-dev01` | Protected API used by `backend-expapi` | Exposes `Chat.ReadWrite` at `api://tech4life-chatapp-expapi-dev01` |

The public-internet model here is:

1. Users sign in to the SPA through **Microsoft Entra External ID**
2. The SPA requests `Chat.ReadWrite` on the backend API
3. The backend validates External ID tokens
4. The backend calls Azure AI Foundry using **its own managed identity**, not user OBO

## Inputs

| Variable | Purpose | Default |
| --- | --- | --- |
| `external_id_tenant_id` | Customer tenant ID used by the `azuread.external` provider | `null` |
| `external_id_tenant_subdomain` | Subdomain for hosted sign-in, e.g. `contoso` for `https://contoso.ciamlogin.com/` | `null` |
| `external_id_custom_domain` | Optional branded auth domain replacing `ciamlogin.com` | `null` |
| `external_id_application_owner_object_ids` | Optional External ID tenant object IDs to own the SPA/API apps | `null` |
| `foundry_owner_upns` | Foundry Owner assignees, looked up by Entra user principal name | `[]` |
| `spa_redirect_uris` | Allowed redirect URIs for the frontend SPA app | `["http://localhost:5173"]` |
| `expapi_identifier_uri` | Optional override for the backend API audience URI | `null` |

If neither `external_id_tenant_subdomain` nor `external_id_custom_domain` is set, the auth outputs intentionally leave `authority` empty because the hosted sign-in domain is still unknown.

For local environment-specific values, keep a file like `vars/external-id.tfvars` and pass it with `-var-file=vars/external-id.tfvars`.

For guest users, prefer the **Entra UPN** form (for example `name_example.com#EXT#@tenant.onmicrosoft.com`) rather than raw email when populating `foundry_owner_upns`. If `foundry_owner_upns` is empty, Terraform falls back to the current runner so the initial bootstrap still works.

## Provider split

This repo now assumes **two identity planes**:

- `azurerm` stays pointed at the Azure subscription tenant that owns Foundry/resources
- `azuread.external` points at the **customer External ID tenant** that will issue end-user tokens

That means your Terraform runner must be able to authenticate to both contexts.

## Outputs for future repos

### `frontend_spa_auth_settings`

Use in `frontend-spa` for Entra External ID MSAL configuration. Redirect URIs that only include scheme + host are normalized with a trailing slash to satisfy Entra app registration rules:

- `tenant_id`
- `client_id`
- `authority`
- `authority_host`
- `redirect_uris`
- `api_scope`
- `user_flow_association_required`

### `backend_expapi_auth_settings`

Use in `backend-expapi` for JWT validation and upstream access wiring:

- `tenant_id`
- `client_id`
- `authority`
- `authority_host`
- `audience`
- `accepted_scopes`
- `token_issuer`
- `upstream_access_model`
- `user_flow_association_required`

## Notes for later backend work

- `backend-expapi` should use **managed identity / app identity** to call Azure AI Foundry.
- Do **not** build the public-user flow around OBO to Foundry; External ID is the customer auth layer, not the Azure resource authorization layer.
- When the backend runtime exists, it will still need its own managed identity and RBAC assignment to the Foundry resource.

## Bootstrap checklist for public sign-up

Before internet users can actually register:

1. Create or choose a **Microsoft Entra External ID** customer tenant.
2. Configure at least one sign-up method, typically email/password and Google.
3. Create a **sign-up and sign-in user flow**.
4. Associate the SPA/API app registrations with that user flow.
5. Point future frontend/backend repos at the emitted authority, tenant, audience, and scope outputs.

## Why this differs from the previous internal Entra/OBO model

- End-user authentication now belongs to **External ID**
- Azure AI Foundry authorization belongs to the **backend's own identity**
- Customer sign-up experiences are mostly **manual External ID tenant configuration**, not standard `azuread` app-registration-only Terraform
