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

# platform, corp en sandbox subscription id's worden als variabelen meegegeven
variable "sub_platform_id" { type = string }
variable "sub_corp_id" { type = string }
variable "sub_sandbox_id" { type = string }
