data "http" "ip" {
  url = "https://ifconfig.me/ip"
}

resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

resource "azurerm_storage_account" "main" {
  name                            = var.storage_account_name
  resource_group_name             = azurerm_resource_group.main.name
  location                        = azurerm_resource_group.main.location
  account_tier                    = "Standard"
  account_replication_type        = "LRS"
  allow_nested_items_to_be_public = false
  min_tls_version                 = "TLS1_2"
  tags                            = var.tags
  access_tier                     = "Cool"

  network_rules {
    default_action = "Deny"
    ip_rules       = [data.http.ip.response_body]
  }

}

resource "azurerm_storage_management_policy" "example" {
  storage_account_id = azurerm_storage_account.main.id

  rule {
    name    = "appdata"
    enabled = true

    filters {
      blob_types = ["blockBlob"]
    }

    actions {
      base_blob {
        delete_after_days_since_modification_greater_than = 60
      }
    }
  }
}

data "healthchecksio_channel" "pushover" {
  kind = "po"
}

resource "healthchecksio_check" "appdata" {
  name     = "Backup Appdata"
  desc     = "Monitors backups from /mnt/user/backups/appdata/ to ${azurerm_storage_account.main.name}:appdata"
  schedule = "0,30 2 * * *" # 2:00 AM and 2:30 AM UTC
  channels = [
    data.healthchecksio_channel.pushover.id,
  ]
}

resource "local_file" "script" {
  filename = "${path.module}/outputs/rclone-appdata.sh"
  content = templatefile("${path.module}/files/rclone-appdata.sh.tpl", {
    ping_url = healthchecksio_check.appdata.ping_url
  })
}
