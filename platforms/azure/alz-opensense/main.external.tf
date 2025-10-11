resource "azurerm_subnet" "external" {
  name                 = "OPNsenseExternalSubnet"
  resource_group_name  = data.azurerm_resource_group.hub.name
  virtual_network_name = data.azurerm_virtual_network.hub.name
  address_prefixes     = ["10.2.1.128/28"]
}

resource "azurerm_network_security_group" "external" {
  name                = "OPNsense01-external-nsg"
  location            = data.azurerm_resource_group.hub.location
  resource_group_name = data.azurerm_resource_group.hub.name

  security_rule {
    name                       = "AllowSSH"
    description                = "Allow SSH for remote management"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = data.http.current_ip.body
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowHTTPS"
    description                = "Allow HTTPS for remote management"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = data.http.current_ip.body
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowWireGuard"
    description                = "Allow WireGuard VPN"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_range     = "51821"
    source_address_prefix      = data.http.current_ip.body
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "external" {
  subnet_id                 = azurerm_subnet.external.id
  network_security_group_id = azurerm_network_security_group.external.id
}
