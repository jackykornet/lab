# This is the main.tf file for the spoke module. It creates a virtual network and a default subnet.

# The virtual network is created with the name, address space, location, and resource group name provided as input variables. The default subnet is created with a name of "snet-default" and an address prefix derived from the first address space of the virtual network.
resource "azurerm_virtual_network" "this" {
  name                = var.name
  address_space       = var.address_space
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

# The default subnet is created with a name of "snet-default" and an address prefix derived from the first address space of the virtual network. The address prefix is calculated using the cidrsubnet function, which takes the first address space of the virtual network, a new prefix length of 8, and a subnet number of 0 to create a /24 subnet.
resource "azurerm_subnet" "default" {
  name                 = "snet-default"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [cidrsubnet(var.address_space[0], 8, 0)] # 10.1.0.0/24
}
