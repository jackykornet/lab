# policy.tf
data "azurerm_policy_definition" "allowed_locations" {
  display_name = "Allowed locations"
}

# azure uses a different policy definition for resource groups, so we need to create a separate assignment for that
data "azurerm_policy_definition" "allowed_locations_rg" {
  display_name = "Allowed locations for resource groups"
}

data "azurerm_policy_definition" "require_rg_tag" {
  display_name = "Require a tag on resource groups"
}

locals {
  allowed_locations = ["westeurope", "northeurope"]
}

resource "azurerm_management_group_policy_assignment" "allowed_locations" {
  name                 = "allowed-locations"
  management_group_id  = azurerm_management_group.root.id
  policy_definition_id = data.azurerm_policy_definition.allowed_locations.id
  parameters = jsonencode({
    listOfAllowedLocations = { value = local.allowed_locations }
  })
}

# azure uses a different policy definition for resource groups, so we need to create a separate assignment for that
resource "azurerm_management_group_policy_assignment" "allowed_locations_rg" {
  name                 = "allowed-locations-rg"
  management_group_id  = azurerm_management_group.root.id
  policy_definition_id = data.azurerm_policy_definition.allowed_locations_rg.id
  parameters = jsonencode({
    listOfAllowedLocations = { value = local.allowed_locations }
  })
}

resource "azurerm_management_group_policy_assignment" "require_owner_tag" {
  name                 = "require-rg-owner-tag"
  management_group_id  = azurerm_management_group.landingzones.id
  policy_definition_id = data.azurerm_policy_definition.require_rg_tag.id
  parameters = jsonencode({
    tagName = { value = "owner" }
  })
}
