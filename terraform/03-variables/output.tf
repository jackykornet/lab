# output "resource_group_id" {
#   value = azurerm_resource_group.lab.id
# }

# for each loop over the resource groups and output their ids
output "resource_group_ids" {
  value = { for k, rg in azurerm_resource_group.workload : k => rg.id }
}
