
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.100"
    }
    # random provider used (needed by sql_server and storage modules)
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }


  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "stg82efa33d"
    container_name       = "tfstate"
    key                  = "dev/terraform.tfstate"
  }
}

# subscription_id is not hardcoded here.
# Terraform's azurerm provider automatically reads ARM_SUBSCRIPTION_ID.

provider "azurerm" {
  features {}
}
