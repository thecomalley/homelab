output "appdata_backup_check_url" {
  value       = healthchecksio_check.appdata.ping_url
  description = "Healthchecks.io ping URL"
}

output "storage_account_name" {
  value       = azurerm_storage_account.main.name
  description = "The name of the storage account"
}

output "storage_account_key" {
  sensitive   = true
  value       = azurerm_storage_account.main.primary_access_key
  description = "The primary access key for the storage account"
}
