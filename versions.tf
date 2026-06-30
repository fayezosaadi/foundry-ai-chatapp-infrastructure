terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 3.5.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 4.70.0"
    }
  }

  required_version = ">= 1.7.5"

  backend "azurerm" {
    resource_group_name  = "shared-rg-dev01"
    storage_account_name = "sharedblobldev01"
    container_name       = "tfstate-dev01"
    key                  = "foundry-chatapp-infra.tfstate"
    use_oidc             = true
  }
}
