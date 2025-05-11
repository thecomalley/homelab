variable proxmox_node {
  type        = string
  default     = "pve"
  description = "The Proxmox node to build on"
}

variable vm_id {
  type        = string
  default     = "999"
  description = "VM ID for the template"
}

variable vm_name {
  type        = string
  default     = "ubuntu-server-noble"
  description = "VM name for the template"
}

variable ssh_username {
  type        = string
  description = "Username for SSH connections"
}

variable ssh_authorized_keys {
  type        = list(string)
  description = "SSH public keys for the user"
}