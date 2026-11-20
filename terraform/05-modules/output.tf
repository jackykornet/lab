output "spoke_vnet_ids" {
  value = {
    app  = module.spoke_app.vnet_id
    data = module.spoke_data.vnet_id
  }
}
