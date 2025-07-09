resource "azurerm_storage_account" "hab" {
  name                     = "omahassprdauebkupst"
  resource_group_name      = azurerm_resource_group.hass.name
  location                 = azurerm_resource_group.hass.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  network_rules {
    default_action = "Deny"
    ip_rules       = [data.http.ip.response_body]
  }

  tags = merge(local.tags, {
    "Component"     = "Home Assistant Backups"
    "Documentation" = "https://www.home-assistant.io/integrations/azure_storage/"
  })
}

resource "azurerm_storage_container" "hab" {
  name                  = "home-assistant-backups"
  storage_account_id    = azurerm_storage_account.hab.id
  container_access_type = "private"
}
