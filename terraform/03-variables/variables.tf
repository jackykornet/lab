variable "environment" {
  type        = string
  description = "dev, tst of prd"
  validation {
    condition     = contains(["dev", "tst", "prd"], var.environment)
    error_message = "Kies dev, tst of prd."
  }
}

variable "location" {
  type    = string
  default = "westeurope"
}

variable "workloads" {
  type    = set(string)
  default = ["app", "mgmt"]
  #default = ["app", "data", "mgmt"]
}
