terraform {
  required_version = ">= 1.15"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.0"
    }
  }
}

provider "azurerm" {
  features {}
  # subscription_id komt uit $env:ARM_SUBSCRIPTION_ID
}

resource "azurerm_resource_group" "lab" {
  name     = "rg-tflab-dev-weu"
  location = "westeurope"
}

resource "azurerm_storage_account" "lab" {
  name                     = "stlabdevweu"
  resource_group_name      = azurerm_resource_group.lab.name
  location                 = azurerm_resource_group.lab.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
