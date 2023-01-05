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

variable "packer_image_name" {
  description = "Name of the Packer image"
  default     = "myPackerImage"
}

variable "packer_resource_group_name" {
  description = "Name of the resource group in which the Packer image will be created"
  default     = "udacity"
}

variable "virtual_machines_count" {
  description = "Number of VMs"
  default = 2
}