# backend.tf
terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate-weu"
    storage_account_name = "sttfstate0002"
    container_name       = "tfstate"
    key                  = "06-caf/dev.tfstate"
    use_azuread_auth     = true
  }
}
