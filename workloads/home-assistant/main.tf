locals {
  tags = {
    WorkloadName = "Home Assistant"
    environment  = "Production"
  }
}

data "http" "ip" {
  url = "https://ifconfig.me/ip"
}

resource "azurerm_resource_group" "hass" {
  name     = "oma-hass-prd-aue-rg"
  location = "Australia East"
  tags     = local.tags
}
