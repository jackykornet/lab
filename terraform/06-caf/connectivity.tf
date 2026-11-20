# connectivity.tf
# --- hub: platform-subscription ---
resource "azurerm_resource_group" "connectivity" {
  provider = azurerm.platform
  name     = "rg-connectivity-${local.suffix}"
  location = var.location
  tags     = local.tags
}

resource "azurerm_virtual_network" "hub" {
  provider            = azurerm.platform
  name                = "vnet-hub-${local.suffix}"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = azurerm_resource_group.connectivity.name
  tags                = local.tags
}

# --- spoke: corp-subscription (standaardprovider) ---
resource "azurerm_resource_group" "corp" {
  name     = "rg-corp-app-${local.suffix}"
  location = var.location
  tags     = local.tags
}


module "spoke_corp" {
  source              = "./modules/spoke"
  name                = "vnet-corp-app-${local.suffix}"
  address_space       = ["10.1.0.0/16"]
  resource_group_name = azurerm_resource_group.corp.name
  location            = var.location
  tags                = local.tags
}

# --- peering: elke kant in de subscription van het eigen VNet ---
resource "azurerm_virtual_network_peering" "hub_to_corp" {
  provider                  = azurerm.platform
  name                      = "peer-hub-to-corp"
  resource_group_name       = azurerm_resource_group.connectivity.name
  virtual_network_name      = azurerm_virtual_network.hub.name
  remote_virtual_network_id = module.spoke_corp.vnet_id
  allow_forwarded_traffic   = true
}

resource "azurerm_virtual_network_peering" "corp_to_hub" {
  # geen provider-regel: aangemaakt in corp
  name                      = "peer-corp-to-hub"
  resource_group_name       = azurerm_resource_group.corp.name
  virtual_network_name      = module.spoke_corp.vnet_name
  remote_virtual_network_id = azurerm_virtual_network.hub.id
  allow_forwarded_traffic   = true
}

# 
module "spoke_corp2" {
  source              = "./modules/spoke"
  name                = "vnet-corp-app2-${local.suffix}"
  address_space       = ["10.2.0.0/16"]
  resource_group_name = azurerm_resource_group.corp.name
  location            = var.location
  tags                = local.tags
}

resource "azurerm_virtual_network_peering" "hub_to_corp2" {
  provider                  = azurerm.platform
  name                      = "peer-hub-to-corp2"
  resource_group_name       = azurerm_resource_group.connectivity.name
  virtual_network_name      = azurerm_virtual_network.hub.name
  remote_virtual_network_id = module.spoke_corp2.vnet_id
  allow_forwarded_traffic   = true
}

resource "azurerm_virtual_network_peering" "corp2_to_hub" {
  name                      = "peer-corp2-to-hub"
  resource_group_name       = azurerm_resource_group.corp.name
  virtual_network_name      = module.spoke_corp2.vnet_name
  remote_virtual_network_id = azurerm_virtual_network.hub.id
  allow_forwarded_traffic   = true
}
