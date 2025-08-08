resource "azurerm_resource_group" "opnsense" {
  name     = "oma-opnsense-prd-aue-rg"
  location = "AustraliaEast" # Change to your preferred Azure region
}

resource "azurerm_virtual_network" "opnsense" {
  name                = "oma-opnsense-prd-aue-vnet"
  address_space       = ["10.10.0.0/16"]
  location            = azurerm_resource_group.opnsense.location
  resource_group_name = azurerm_resource_group.opnsense.name
}

resource "azurerm_subnet" "internal" {
  name                 = "oma-opnsense-prd-aue-internal-snet"
  resource_group_name  = azurerm_resource_group.opnsense.name
  virtual_network_name = azurerm_virtual_network.opnsense.name
  address_prefixes     = ["10.10.1.0/24"]
}

resource "azurerm_subnet" "external" {
  name                 = "oma-opnsense-prd-aue-external-snet"
  resource_group_name  = azurerm_resource_group.opnsense.name
  virtual_network_name = azurerm_virtual_network.opnsense.name
  address_prefixes     = ["10.10.0.0/24"]
}

resource "azurerm_network_security_group" "external" {
  name                = "oma-opnsense-prd-aue-external-snet-nsg"
  location            = azurerm_resource_group.opnsense.location
  resource_group_name = azurerm_resource_group.opnsense.name

  security_rule {
    name                       = "AllowSSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "external" {
  subnet_id                 = azurerm_subnet.external.id
  network_security_group_id = azurerm_network_security_group.external.id
}

resource "azurerm_public_ip" "external" {
  name                = "opnsense-prd-aue01-external-pip"
  location            = azurerm_resource_group.opnsense.location
  resource_group_name = azurerm_resource_group.opnsense.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "nic_external" {
  name                  = "opnsense-prd-aue01-external-nic"
  location              = azurerm_resource_group.opnsense.location
  resource_group_name   = azurerm_resource_group.opnsense.name
  ip_forwarding_enabled = true

  ip_configuration {
    name                          = "external"
    subnet_id                     = azurerm_subnet.external.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.external.id
  }
}

resource "azurerm_network_interface" "nic_internal" {
  name                  = "opnsense-prd-aue01-internal-nic"
  location              = azurerm_resource_group.opnsense.location
  resource_group_name   = azurerm_resource_group.opnsense.name
  ip_forwarding_enabled = true

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Note: Replace the image below with an official OpenSense image if available in Azure Marketplace.
# For demo, using Ubuntu. You may need to bring your own OpenSense image (custom VHD) for production.
resource "azurerm_linux_virtual_machine" "opnsense" {
  name                = "opnsense-prd-aue01"
  resource_group_name = azurerm_resource_group.opnsense.name
  location            = azurerm_resource_group.opnsense.location
  size                = "Standard_B2ats_v2"
  admin_username      = "azureuser"

  network_interface_ids = [
    azurerm_network_interface.nic_external.id,
    azurerm_network_interface.nic_internal.id
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "StandardSSD_LRS"
    name                 = "opnsense-osdisk"
  }

  source_image_reference {
    publisher = "thefreebsdfoundation"
    offer     = "freebsd-14_2"
    sku       = "14_2-release-zfs"
    version   = "latest"
  }

  plan {
    name      = "14_2-release-zfs"
    publisher = "thefreebsdfoundation"
    product   = "freebsd-14_2"
  }

  boot_diagnostics {
    storage_account_uri = null # Uses managed boot diagnostics
  }

  tags = {
    environment = "lab"
  }
}

# Output public IP for access
output "external_vm_public_ip" {
  value       = azurerm_public_ip.external.ip_address
  description = "Public IP address of the OpenSense VM external NIC"
}

output "provisioning_commands" {
  value       = <<EOT
scp -o StrictHostKeyChecking=no ./cloud_init.sh ./config.xml azureuser@${azurerm_public_ip.external.ip_address}:/home/azureuser
ssh -o StrictHostKeyChecking=no azureuser@${azurerm_public_ip.external.ip_address} "chmod +x /home/azureuser/cloud_init.sh && sh /home/azureuser/cloud_init.sh"
EOT
  description = "Commands to provision the OpenSense VM"
}
