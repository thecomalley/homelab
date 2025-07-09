resource "azurerm_ai_foundry" "example" {
  name                = "exampleaihub"
  location            = azurerm_ai_services.example.location
  resource_group_name = azurerm_resource_group.example.name
  storage_account_id  = azurerm_storage_account.example.id
  key_vault_id        = azurerm_key_vault.example.id

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_ai_foundry_project" "example" {
  name               = "example"
  location           = azurerm_ai_foundry.example.location
  ai_services_hub_id = azurerm_ai_foundry.example.id
}
