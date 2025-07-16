packer {
  required_plugins {
    windows-update = {
      version = "0.16.10"
      source  = "github.com/rgl/windows-update"
    }
    proxmox = {
      version = "~> 1"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

source "proxmox-iso" "windows_server_2022" {
  node = "pve"

  vm_name = "windows-server-2022"
  vm_id                = 2022
  template_name        = "windows-server-2022"
  template_description = <<EOF
Windows Server 2022 Template for Packer

Created by Packer on ${formatdate("DD MMM YYYY hh:mm ZZZ", timestamp())}
    EOF

  # communicator
  communicator         = "ssh"
  ssh_username         = "Administrator"
  ssh_private_key_file = var.private_key_path
  ssh_timeout          = "30m"

  bios    = "ovmf"
  machine = "q35"

  cores              = 2
  memory             = 4096
  ballooning_minimum = 0
  sockets            = var.socket
  cpu_type           = "host"
  os                 = "win11"

  efi_config {
    efi_storage_pool  = var.efi_storage
    pre_enrolled_keys = true
    efi_type          = "4m"
  }

  # Boot ISO | maps to E:\
  boot_iso {
    iso_file = var.windows_iso
    unmount  = true
  }

  scsi_controller = "virtio-scsi-pci"
  additional_iso_files {
    iso_storage_pool = "local"
    unmount          = true
    cd_files = [
      "../drivers/2022/*",
      "../scripts/bootstrap.ps1",
      "../installers/virtio-win-gt-x64.msi",
      "../installers/qemu-ga-x86_64.msi",
    ]
    cd_content = {
      "Autounattend.xml" = templatefile("../files/2022/Autounattend.xml.pkrtpl", {
        ProductKey            = var.product_key
        TimeZone              = var.time_zone
        AdministratorPassword = var.administrator_password
      })
      "EnableSSH.ps1" = templatefile("../templates/EnableSSH.ps1", {
        publicKey = chomp(file(var.public_key_path))
      })
    }
  }

  # Network
  network_adapters {
    model    = "virtio"
    bridge   = var.bridge
    vlan_tag = var.vlan
  }

  # Storage
  disks {
    storage_pool = "nvme"
    # storage_pool_type = "btrfs"
    type       = "scsi"
    disk_size  = var.disk_size_gb
    cache_mode = "writeback"
    format     = "raw"
  }

  # Boot
  boot_wait = "5s"
  boot_command = [
    "<enter>"
  ]
}

build {
  name    = "Proxmox Build"
  sources = ["source.proxmox-iso.windows_server_2022"]

  provisioner "windows-restart" {}

  # Windows Updates keeps crashing the build, so it's disabled for now
  # provisioner "windows-update" {
  #   search_criteria = "IsInstalled=0"
  #   update_limit = 10
  # }

  provisioner "powershell" {
    pause_before = "15s"
    script       = "../scripts/EnableWinRM.ps1"
    pause_after  = "15s"
  }

  provisioner "powershell" {
    pause_before = "15s"
    script       = "../scripts/EnableRDP.ps1"
    pause_after  = "15s"
  }

  # Sysprep the VM
  provisioner "file" {
    source      = "../files/2022/unattend.xml"
    destination = "C:/Windows/System32/Sysprep/unattend.xml"
  }

  provisioner "powershell" {
    pause_before     = "15s"
    script           = "../scripts/Sysprep.ps1"
    valid_exit_codes = [0, 1, 2300218, -1] # 2300218 is when Packer loses connection to the VM after Sysprep
    pause_after      = "10s"
    timeout          = "15m"
  }
}