terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
    }
  }
}

provider "proxmox" {
  pm_tls_insecure             = true
  pm_minimum_permission_check = false
  # Configuration options
}
