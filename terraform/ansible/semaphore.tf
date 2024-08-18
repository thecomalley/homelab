data "azuread_client_config" "current" {}

resource "azuread_application" "semaphore" {
  display_name = "semaphore"
}

resource "azuread_service_principal" "semaphore" {
  client_id = azuread_application.semaphore.client_id
}

resource "azuread_service_principal_password" "semaphore" {
  service_principal_id = azuread_service_principal.semaphore.object_id
}

output "semaphore_env_vars" {
  sensitive = true
  value = {
    "AZURE_SUBSCRIPTION_ID" = data.azurerm_client_config.current.subscription_id
    "AZURE_CLIENT_ID"       = azuread_application.semaphore.client_id
    "AZURE_SECRET"          = azuread_service_principal_password.semaphore.value
    "AZURE_TENANT"          = data.azurerm_client_config.current.tenant_id
  }
}
