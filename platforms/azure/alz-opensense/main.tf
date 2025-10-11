resource "azurerm_public_ip" "external" {
  name                = "OPNsense01-external-pip"
  location            = data.azurerm_resource_group.hub.location
  resource_group_name = data.azurerm_resource_group.hub.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_network_interface" "nic_external" {
  name                  = "OPNsense01-external-nic"
  location              = data.azurerm_resource_group.hub.location
  resource_group_name   = data.azurerm_resource_group.hub.name
  ip_forwarding_enabled = true

  ip_configuration {
    name                          = "external"
    subnet_id                     = azurerm_subnet.external.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.external.id
  }
}

resource "azurerm_network_interface" "nic_internal" {
  name                  = "OPNsense01-internal-nic"
  location              = data.azurerm_resource_group.hub.location
  resource_group_name   = data.azurerm_resource_group.hub.name
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
  name                = "OPNsense01"
  resource_group_name = data.azurerm_resource_group.hub.name
  location            = data.azurerm_resource_group.hub.location
  size                = "Standard_F2ams_v6" # Change to Standard_B1ls once provisioned
  admin_username      = "azureuser"

  # Spot instance configuration
  priority        = "Spot"
  eviction_policy = "Deallocate"
  max_bid_price   = 0.0132 # Price of Standard_B1s in Australia East as of 2025-09-03

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
    storage_account_type = "Premium_LRS" # Change to Standard_SSD once provisioned
    name                 = "OPNsense01-osdisk"
  }

  source_image_reference {
    publisher = "thefreebsdfoundation"
    offer     = "freebsd-14_2"
    sku       = "14_2-release-zfs"
    version   = "14.2.0"
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
