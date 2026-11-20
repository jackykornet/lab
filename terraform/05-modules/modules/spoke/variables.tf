# This file contains the variables for the spoke module.
variable "name" { type = string }
variable "address_space" { type = list(string) }
variable "resource_group_name" { type = string }
variable "location" { type = string }
variable "tags" {
  type    = map(string)
  default = {}
}
