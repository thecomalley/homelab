variable install_mode {
  type        = string
  default     = "desktop"
  description = "Template type, can be desktop or core"
  validation {
    condition     = (var.install_mode == "desktop") || (var.install_mode == "core")
    error_message = "Should be desktop or core."
  }
}

variable proxmox_url {
  type        = string
  description = "Proxmox Server URL"
}

variable node {
  type        = string
  description = "Proxmox cluster node"
}

variable windows_iso {
  type        = string
  description = "Location of ISO file in the Proxmox environment"
}

variable iso_storage_pool {
  type        = string
  description = "Proxmox storage location for additional iso files"
}

variable efi_storage {
  type        = string
  description = "Location of EFI storage on proxmox host"
}

variable memory {
  type        = number
  description = "VM memory in MB"
}

variable cores {
  type        = number
  description = "Amount of CPU cores"
}

variable socket {
  type        = number
  description = "Amount of CPU sockets"
}

variable vlan {
  type        = number
  description = "Network VLAN Tag"
}

variable bridge {
  type        = string
  description = "Network bridge name"
}

variable disk_storage {
  type        = string
  description = "Disk storage location"
}

variable disk_size_gb {
  type        = string
  description = " Disk size including GB so <size>GB"
}

variable winrm_user {
  type        = string
  description = "WinRM user"
}

variable cdrom_drive {
  type        = string
  description = "CD-ROM Driveletter for extra iso"
  default     = "D:"
}

variable public_key_path {
  type        = string
  description = "Path to the public SSH key"
  default     = "~/.ssh/id_rsa.pub"
}

variable private_key_path {
  type        = string
  description = "Path to the private SSH key"
  default     = "~/.ssh/id_rsa"
}

variable min_memory {
  type        = string
  description = "Minimum memory for ballooning in MB"
  default     = "1024"
}

variable administrator_password {
  type        = string
  description = "Administrator password for the Windows VM"
  default     = "P@ssw0rd1234!"
}

variable timezone {
  type        = string
  description = "Timezone for the Windows VM"
  default     = "New Zealand Standard Time"
}

variable product_key {
  type        = string
  description = "Windows product key"
  default     = "MFY9F-XBN2F-TYFMP-CCV49-RMYVH" # Windows Server Insiders Preview
}

variable image_name {
  type        = string
  description = "Name of the image to be installed from the ISO"
  default     = "Windows Server 2025 SERVERSTANDARD"
}


variable vm_id {
  type        = number
  description = "VM ID for the Proxmox VM"
  default     = 2025
}