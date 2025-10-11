resource "azurerm_subnet" "internal" {
  name                 = "OPNsenseInternalSubnet"
  resource_group_name  = data.azurerm_resource_group.hub.name
  virtual_network_name = data.azurerm_virtual_network.hub.name
  address_prefixes     = ["10.2.1.96/28"]
}

resource "azurerm_network_security_group" "internal" {
  name                = "OPNsense01-internal-nsg"
  location            = data.azurerm_resource_group.hub.location
  resource_group_name = data.azurerm_resource_group.hub.name
}

resource "azurerm_subnet_network_security_group_association" "internal" {
  subnet_id                 = azurerm_subnet.internal.id
  network_security_group_id = azurerm_network_security_group.internal.id
}
