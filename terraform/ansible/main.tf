data "azurerm_client_config" "current" {}

locals {
  names = {
    azurerm_resource_group = "rg-ansible-prd-aue"
    azurerm_key_vault      = "kv-ansible-prd-aue"
  }
}

resource "azurerm_resource_group" "ansible" {
  name     = local.names.azurerm_resource_group
  location = "Australia East"
}

resource "azurerm_key_vault" "ansible" {
  name                = local.names.azurerm_key_vault
  location            = azurerm_resource_group.ansible.location
  resource_group_name = azurerm_resource_group.ansible.name

  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  enable_rbac_authorization = true

  sku_name = "standard"
}

resource "azurerm_role_assignment" "ansible" {
  scope                = azurerm_key_vault.ansible.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
}
