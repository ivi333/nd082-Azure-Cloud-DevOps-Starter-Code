provider "azurerm" {
  features {}
}

#resource group
resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-resources"
  location = var.location
  tags = {
    createdBy = var.createdBy
  }
}

#public ip
resource "azurerm_public_ip" "main" {
  name                = "${var.prefix}-publicIP"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Static"
  tags = {
    createdBy = var.createdBy
  }
 }

#Networking
resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = ["10.20.0.0/16"]
  tags = {
    createdBy = var.createdBy
  }
}

resource "azurerm_subnet" "main" {
  name                 = "${var.prefix}-internal"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.20.10.0/24"]

}

resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic-${count.index + 1}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  count               = var.virtual_machines_count
  ip_configuration {
    name                          = "ipconfig-${count.index + 1}"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
  }
  tags = {
    createdBy = var.createdBy
  }
}

resource "azurerm_network_security_group" "main" {
  name                = "${var.prefix}-network-sg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "${var.prefix}-DenyAnyHttpOutbound-1"
    priority                   = 1051
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }

  security_rule {
    name                       = "${var.prefix}-DenyAnyHttpOutbound-2"
    priority                   = 1052
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  }

  security_rule {
    name                       = "${var.prefix}-AllowVNSubnetInBound"
    priority                   = 1051
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  }

  tags = {
    createdBy = var.createdBy
  }
}

resource "azurerm_subnet_network_security_group_association" "main" {
  subnet_id                     = azurerm_subnet.main.id
  network_security_group_id     = azurerm_network_security_group.main.id
}

data "azurerm_resource_group" "image" {
  name                = var.packer_resource_group_name
}
data "azurerm_image" "image" {
  name                = var.packer_image_name
  resource_group_name = data.azurerm_resource_group.image.name
}

#Load Balancer
resource "azurerm_lb" "main" {
  name                = "${var.prefix}-loadbalancer"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  frontend_ip_configuration {
    name                          = "${var.prefix}-primary"
    public_ip_address_id          = azurerm_public_ip.main.id
  }

  tags = {
    createdBy = var.createdBy
  }
}

resource "azurerm_lb_backend_address_pool" "main" {
  loadbalancer_id = azurerm_lb.main.id
  name            = "${var.prefix}-backend-pool"
}

resource "azurerm_network_interface_backend_address_pool_association" "main" {
  count                   = var.virtual_machines_count
  network_interface_id    = azurerm_network_interface.main.*.id[count.index]
  ip_configuration_name   = azurerm_network_interface.main.*.ip_configuration.0.name[count.index]
  backend_address_pool_id = azurerm_lb_backend_address_pool.main.id
}

#Availability set
resource "azurerm_availability_set" "main" {
  name                          = "${var.prefix}-availability-sets"
  location                      = azurerm_resource_group.main.location
  resource_group_name           = azurerm_resource_group.main.name
  platform_fault_domain_count   = var.virtual_machines_count
  platform_update_domain_count  = var.virtual_machines_count
  managed                       = true
  tags = {
    createdBy = var.createdBy
  }
}

#Virtual machine
resource "azurerm_linux_virtual_machine" "main" {
  count                           = var.virtual_machines_count
  name                            = "${var.prefix}-vm-${count.index}"
  resource_group_name             = azurerm_resource_group.main.name
  availability_set_id             = azurerm_availability_set.main.id
  location                        = azurerm_resource_group.main.location
  size                            = "Standard_B1s"
  admin_username                  = var.username
  admin_password                  = var.password
  disable_password_authentication = false
  network_interface_ids = [
    element(azurerm_network_interface.main.*.id, count.index)]

  /*source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }*/

  source_image_id = data.azurerm_image.image.id

  os_disk {
    name                 = "${var.prefix}-disk-${count.index}"
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  tags = {
    createdBy = var.createdBy
  }
}
