variable "prefix" {
  description = "The prefix which should be used for all resources in this example"
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
  default = "francecentral"
}

variable "username" {
  description = "Username for the VM"
  default = "useradmin"
}

variable "password" {
  description = "Username for the VM"
  default = "Barcelona1!"
}

variable "createdBy" {
  description = "Created by User"
  default = "IvanG"
}
