output "account_name" {
  description = "Name of the storage account"
  value       = azurerm_storage_account.hab.name
}

output "storage_account_key" {
  description = "Storage account access key used for authorization"
  value       = azurerm_storage_account.hab.primary_access_key
  sensitive   = true
}
