terraform {
  required_version = "~> 1.15.0"

  backend "azurerm" {
    resource_group_name  = "rg-terraform-prd1"
    storage_account_name = "sttfstateprd1"
    container_name       = "chatapp"
    key                  = "chatapp-infra.tfstate"
    use_oidc             = true
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.0.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 3.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.8.1"
    }
  }
}
