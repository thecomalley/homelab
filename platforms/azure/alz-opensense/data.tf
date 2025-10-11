data "http" "current_ip" {
  url = "https://ifconfig.me/ip"
}

data "azurerm_resource_group" "hub" {
  name = "alzv2-hub-sbx-aue-rg"
}

data "azurerm_virtual_network" "hub" {
  name                = "alzv2-hub-sbx-aue-vnet"
  resource_group_name = "alzv2-hub-sbx-aue-rg"
}
