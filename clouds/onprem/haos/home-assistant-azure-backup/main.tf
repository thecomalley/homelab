locals {
  tags = {
    WorkloadName = "Home Assistant Backups"
    environment  = "Home Production"
  }
}

data "http" "ip" {
  url = "https://ifconfig.me/ip"
}

resource "azurerm_resource_group" "hab" {
  name     = "oma-hab-hprd-aue-rg"
  location = "Australia East"
  tags     = local.tags
}

resource "azurerm_storage_account" "hab" {
  name                     = "omahabhprdauest"
  resource_group_name      = azurerm_resource_group.hab.name
  location                 = azurerm_resource_group.hab.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  network_rules {
    default_action = "Deny"
    ip_rules       = [data.http.ip.response_body]
  }

  tags = local.tags
}

resource "azurerm_storage_container" "hab" {
  name                  = "home-assistant-backups"
  storage_account_id    = azurerm_storage_account.hab.id
  container_access_type = "private"
}

