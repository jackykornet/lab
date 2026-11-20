locals {
  loc_short = { westeurope = "weu", northeurope = "neu" }[var.location]
  suffix    = "${var.environment}-${local.loc_short}"
  tags = {
    environment = var.environment
    managed_by  = "terraform"
    owner       = "jacky"
  }
}
