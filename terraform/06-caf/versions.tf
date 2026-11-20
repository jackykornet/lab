# versions.tf
# this is the place to specify the required terraform version and the required providers with their versions
# previous in main but this is not necessary anymore, but it is good practice to have this in a separate file
terraform {
  required_version = ">= 1.15"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 5.0"
    }
  }
}

# standaard provider voor de root management group en de subscriptions onder de root management group
# provider voor corp subscription
provider "azurerm" {
  features {}
  subscription_id = var.sub_corp_id
}

# provider voor de platform subscription
provider "azurerm" {
  alias = "platform"
  features {}
  subscription_id = var.sub_platform_id
}

# provider voor de sandbox subscription
provider "azurerm" {
  alias = "sandbox"
  features {}
  subscription_id = var.sub_sandbox_id
}
