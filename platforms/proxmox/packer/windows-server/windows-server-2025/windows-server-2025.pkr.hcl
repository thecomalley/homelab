packer {
  required_plugins {
    windows-update = {
      version = "0.16.10"
      source  = "github.com/rgl/windows-update"
    }
    proxmox = {
      version = "1.2.1" # https://github.com/hashicorp/packer-plugin-proxmox/issues/307
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

source "proxmox-iso" "windows_server_2025" {
  insecure_skip_tls_verify = true
  node                     = var.node

  bios     = "ovmf"      # OVMF is the UEFI BIOS for QEMU/KVM
  machine  = "q35"       # Q35 is the recommended machine type for modern OSes
  cpu_type = "x86-64-v3" # Seams to be the best option for Windows Server 2025

  # EFI Configuration
  efi_config {
    efi_storage_pool  = var.efi_storage
    pre_enrolled_keys = true
    efi_type          = "4m"
  }

  tpm_config {
    tpm_storage_pool = var.efi_storage
  }

  additional_iso_files {
    iso_storage_pool = "local"
    unmount          = true
    cd_files = [
      "../drivers/2025/*",
      "../scripts/bootstrap.ps1",
      "../installers/virtio-win-gt-x64.msi",
      "../installers/qemu-ga-x86_64.msi",
    ]
    cd_content = {
      "Autounattend.xml" = templatefile("../files/2025/Autounattend.xml.pkrtpl", {
        ProductKey            = var.product_key
        TimeZone              = var.time_zone
        AdministratorPassword = var.administrator_password
      })
      "EnableSSH.ps1" = templatefile("../templates/EnableSSH.ps1", {
        publicKey = chomp(file(var.public_key_path))
      })
    }
  }


  template_name        = "windows-server-2025-${var.install_mode}"
  template_description = "Packer Template for Windows Server 2025 (${var.install_mode})"
  vm_name              = "windows-server-2025-${var.install_mode}"
  vm_id                = var.vm_id
  memory               = var.memory
  ballooning_minimum   = var.min_memory
  cores                = var.cores
  sockets              = var.socket
  os                   = "win11"

  # Network
  network_adapters {
    model    = "virtio"
    bridge   = "vmbr0"
  }

  # Storage
  scsi_controller = "virtio-scsi-single"
  disks {
    type         = "scsi"
    io_thread    = true
    ssd          = true
    discard      = true
    disk_size    = var.disk_size
    storage_pool = "local-lvm"
    format       = "raw" 
  }
  boot_iso {
    iso_file = var.windows_iso
    unmount  = true
  }

  # WinRM
  communicator         = "ssh"
  ssh_username         = "Administrator"
  ssh_private_key_file = var.private_key_path
  ssh_timeout          = "30m"

  # Boot
  boot_wait = "5s"
  boot_command = [
    "<enter>"
  ]
}

build {
  name    = "Proxmox Build"
  sources = ["source.proxmox-iso.windows_server_2025"]

  provisioner "windows-restart" {}

  # Windows Updates keeps crashing the build, so it's disabled for now
  # provisioner "windows-update" {
  #   search_criteria = "IsInstalled=0"
  #   update_limit = 10
  # }

  # Configure Windows
  provisioner "powershell" {
    pause_before     = "15s"
    script           = "../scripts/CreateAnsibleUser.ps1"
    pause_after      = "15s"
  }

  provisioner "powershell" {
    pause_before     = "15s"
    script           = "../scripts/EnableWinRM.ps1"
    pause_after      = "15s"
  }

  provisioner "powershell" {
    pause_before     = "15s"
    script           = "../scripts/EnableRDP.ps1"
    pause_after      = "15s"
  }

  # Sysprep the VM
  provisioner "file" {
    source      = "../files/2025/unattend.xml"
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