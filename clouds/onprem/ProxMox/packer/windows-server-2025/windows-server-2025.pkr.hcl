packer {
  required_plugins {
    proxmox = {
      version = "~> 1"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

source "proxmox-iso" "windows-server-2025" {

  # Proxmox settings
  insecure_skip_tls_verify = true
  node                     = var.proxmox_node

  # VM General Settings
  vm_id   = "900"
  vm_name = "windows-server-2025"

  # BIOS - UEFI
  bios = "ovmf"

  # Machine type
  # Q35 less resource overhead and newer chipset
  machine = "q35"

  efi_config {
    efi_storage_pool  = var.efi_storage
    pre_enrolled_keys = true
    efi_type          = "4m"
  }

  # Windows Server ISO File
  iso_file    = var.windows_iso
  unmount_iso = true


  # virtio drivers
  additional_iso_files {
    type         = "scsi"
    iso_file     = "local:iso/virtio-win-0.1.271.iso"
    unmount      = true
  }


  additional_iso_files {
    cd_files = ["./build_files/drivers/*", "./build_files/scripts/ConfigureRemotingForAnsible.ps1", "./build_files/software/virtio-win-guest-tools.exe"]
    cd_content = {
      "autounattend.xml" = templatefile("./build_files/templates/unattend.pkrtpl", { password = local.winrm_password, cdrom_drive = var.cdrom_drive, index = lookup(var.image_index, var.template, "core") })
    }
    cd_label         = "Unattend"
    iso_storage_pool = var.iso_storage
    unmount          = true
    device           = "sata0"
  }

  template_name           = "templ-win2022-${var.template}"
  template_description    = "Created on: ${timestamp()}"
  memory                  = var.memory
  cores                   = var.cores
  sockets                 = var.socket
  cpu_type                = "host"
  os                      = "win11"
  scsi_controller         = "virtio-scsi-pci"
  cloud_init              = false
  cloud_init_storage_pool = var.cloud_init_storage

  # Network
  network_adapters {
    model    = "virtio"
    bridge   = var.bridge
    vlan_tag = var.vlan
  }

  # Storage
  disks {
    storage_pool = var.disk_storage
    # storage_pool_type = "btrfs"
    type       = "scsi"
    disk_size  = var.disk_size_gb
    cache_mode = "writeback"
    format     = "raw"
  }

  # WinRM
  communicator   = "winrm"
  winrm_username = var.winrm_user
  winrm_password = local.winrm_password
  winrm_timeout  = "12h"
  winrm_port     = "5986"
  winrm_use_ssl  = true
  winrm_insecure = true

  # Boot
  boot_wait = "7s"
  boot_command = [
    "<enter>"
  ]
}

build {
  name    = "Proxmox Build"
  sources = ["source.proxmox-iso.windows-server-2025"]

}