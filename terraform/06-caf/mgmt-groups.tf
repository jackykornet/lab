# mgmt-groups.tf
resource "azurerm_management_group" "root" {
  name         = "tenrok"
  display_name = "Tenrok"
  # geen parent = direct onder de Tenant Root Group
}

resource "azurerm_management_group" "platform" {
  name                       = "tenrok-platform"
  display_name               = "Platform"
  parent_management_group_id = azurerm_management_group.root.id
}

# normally management is a child of platform, but for this lab we put it under root to make it easier to see the effect of the policy assignment
resource "azurerm_management_group" "management" {
  name                       = "tenrok-management"
  display_name               = "Management"
  parent_management_group_id = azurerm_management_group.platform.id
}

# normally connectivity is a child of platform, but for this lab we put it under root to make it easier to see the effect of the policy assignment
resource "azurerm_management_group" "connectivity" {
  name                       = "tenrok-connectivity"
  display_name               = "Connectivity"
  parent_management_group_id = azurerm_management_group.platform.id
}

resource "azurerm_management_group" "landingzones" {
  name                       = "tenrok-landingzones"
  display_name               = "Landing zones"
  parent_management_group_id = azurerm_management_group.root.id
}

resource "azurerm_management_group" "corp" {
  name                       = "tenrok-corp"
  display_name               = "Corp"
  parent_management_group_id = azurerm_management_group.landingzones.id
}

resource "azurerm_management_group" "sandbox" {
  name                       = "tenrok-sandbox"
  display_name               = "Sandbox"
  parent_management_group_id = azurerm_management_group.root.id
}

# elke subscription onder zijn eigen management group
resource "azurerm_management_group_subscription_association" "platform" {
  management_group_id = azurerm_management_group.platform.id
  subscription_id     = "/subscriptions/${var.sub_platform_id}"
}

resource "azurerm_management_group_subscription_association" "corp" {
  management_group_id = azurerm_management_group.corp.id
  subscription_id     = "/subscriptions/${var.sub_corp_id}"
}

resource "azurerm_management_group_subscription_association" "sandbox" {
  management_group_id = azurerm_management_group.sandbox.id
  subscription_id     = "/subscriptions/${var.sub_sandbox_id}"
}
