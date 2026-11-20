# management.tf
resource "azurerm_resource_group" "management" {
  provider = azurerm.platform
  name     = "rg-management-${local.suffix}"
  location = var.location
  tags     = local.tags
}

# This one is normally create in the management subscription, but we create it in the platform subscription for this lab
resource "azurerm_log_analytics_workspace" "main" {
  provider            = azurerm.platform
  name                = "law-management-${local.suffix}"
  location            = var.location
  resource_group_name = azurerm_resource_group.management.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  daily_quota_gb      = 0.5
  tags                = local.tags
}

# setup the diagnostic setting for the corp subscription and send the logs to the log analytics workspace in the platform subscription
resource "azurerm_monitor_diagnostic_setting" "activity_corp" {
  name                       = "diag-activitylog-to-law"
  target_resource_id         = "/subscriptions/${var.sub_corp_id}"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id

  enabled_log {
    category = "Administrative"
  }
}

# setup the diagnostic setting for the platform subscription and send the logs to the log analytics workspace in the platform subscription
resource "azurerm_monitor_diagnostic_setting" "activity_platform" {
  provider                   = azurerm.platform
  name                       = "diag-activitylog-to-law"
  target_resource_id         = "/subscriptions/${var.sub_platform_id}"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id

  enabled_log {
    category = "Administrative"
  }
}

# setup the diagnostic setting for the sandbox subscription and send the logs to the log analytics workspace in the platform subscription
resource "azurerm_monitor_diagnostic_setting" "activity_sandbox" {
  provider                   = azurerm.sandbox
  name                       = "diag-activitylog-to-law"
  target_resource_id         = "/subscriptions/${var.sub_sandbox_id}"
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id

  enabled_log {
    category = "Administrative"
  }
}
