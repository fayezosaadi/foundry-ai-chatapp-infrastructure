terraform {
  required_version = ">= 1.7.5"

  backend "azurerm" {
    resource_group_name  = "rg-terraform-prd1"
    storage_account_name = "sttfstateprd1"
    container_name       = "chatapp"
    key                  = "chatapp-infra.tfstate"
    use_oidc             = true
  }

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
}
