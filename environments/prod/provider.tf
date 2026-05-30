terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
  }

  # Remote backend (recommended)
  # backend "azurerm" {
  #   resource_group_name  = "rg-terraform-state"
  #   storage_account_name = "tfstatestorage123"
  #   container_name       = "tfstate"
  #   key                  = "dev/terraform.tfstate"
  # }
}

provider "azurerm" {
  features {}

  subscription_id = "baa60071-a8e6-4ec4-ad1e-1d7c4f9673b8"
}
