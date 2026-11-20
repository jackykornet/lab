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

resource "azurerm_resource_group" "net" {
  name     = "rg-network-${local.suffix}"
  location = var.location
  tags     = local.tags
}

module "spoke_app" {
  source = "./modules/spoke" # pad naar de module-map, relatief aan deze map

  # elke regel vult een variable uit modules/spoke/variables.tf
  name                = "vnet-app-${local.suffix}"
  address_space       = ["10.1.0.0/16"]
  resource_group_name = azurerm_resource_group.net.name
  location            = var.location
  tags                = local.tags
}

module "spoke_data" {
  source = "./modules/spoke"

  name                = "vnet-data-${local.suffix}"
  address_space       = ["10.2.0.0/16"]
  resource_group_name = azurerm_resource_group.net.name
  location            = var.location
  tags                = local.tags
}
