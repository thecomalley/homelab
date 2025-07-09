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
  insecure_skip_tls_verify = true
  node                     = var.node

  bios    = "ovmf" # OVMF is the UEFI BIOS for QEMU/KVM
  machine = "q35"  # Q35 is the recommended machine type for modern OSes

  # EFI Configuration
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

  # BuildFiles | maps to D:\
  additional_iso_files {
    iso_storage_pool = var.iso_storage_pool
    unmount          = true
    cd_label         = "BuildFiles"
    cd_files = [
      "./drivers/*",
      "../build_files/virtio-win-guest-tools.exe",
    ]
    # Generate some files with values provided by Packer
    cd_content = {

      # The Autounattend.xml file is used for unattended installation of Windows
      "Autounattend.xml" = templatefile("./templates/Autounattend.xml.pkrtpl", {
        ImageIndex            = var.image_index,
        ProductKey            = var.product_key,
        TimeZone              = var.timezone,
        AdministratorPassword = var.administrator_password,
      })

      # Inject the SSH key into the ConfigureSSHForAnsible script
      "EnableSSH.ps1" = templatefile("./templates/EnableSSH.ps1", {
        publicKey = chomp(file(var.public_key_path))
      })
    }
  }

  template_name        = "windows-server-2022-${var.install_mode}"
  template_description = "Packer Template for Windows Server 2022 (${var.install_mode})"
  vm_name              = "windows-server-2022-${var.install_mode}"
  vm_id                = var.vm_id
  memory               = var.memory
  ballooning_minimum   = var.min_memory
  cores                = var.cores
  sockets              = var.socket
  cpu_type             = "host"
  os                   = "win11"
  scsi_controller      = "virtio-scsi-pci"

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
  communicator         = "ssh"
  ssh_username         = "Administrator"
  ssh_private_key_file = var.private_key_path
  ssh_timeout          = "30m"

  # Boot
  boot_wait = "7s"
  boot_command = [
    "<enter>"
  ]
}

build {
  name    = "Proxmox Build"
  sources = ["source.proxmox-iso.windows_server_2022"]

  # Reboot the VM
  provisioner "windows-restart" {}

  # CreateAnsibleUser
  provisioner "powershell" {
    name   = "CreateAnsibleUser"
    script = "../build_files/CreateAnsibleUser.ps1"
  }

  # DisableIPv6
  provisioner "powershell" {
    name   = "DisableIPv6"
    script = "../build_files/DisableIPv6.ps1"
  }

  # Disable PrintSpooler  
  provisioner "powershell" {
    name   = "DisablePrintSpooler"
    script = "../build_files/DisablePrintSpooler.ps1"
  }

  # Disable SMBv1
  provisioner "powershell" {
    name   = "DisableSMBv1"
    script = "../build_files/DisableSMBv1.ps1"
  }

  # Enable RDP
  provisioner "powershell" {
    name   = "EnableRDP"
    script = "../build_files/EnableRDP.ps1"
  }

  # Sysprep the VM
  provisioner "powershell" {
    inline = [
      # C:\Windows\System32\sysprep\sysprep.exe /generalize /oobe /quiet /unattend:D:\Autounattend.xml
      "C:\\Windows\\System32\\sysprep\\sysprep.exe /generalize /oobe /quiet /unattend:D:\\Autounattend.xml"
    ]
  }

  # Breakpoint for manual intervention
  provisioner "breakpoint" {
    note = "This is a breakpoint. Please check the VM and ensure sysprep was successful."
  }

  # Wait for 60 seconds to allow sysprep to complete
  provisioner "shell-local" {
    inline = ["sleep 60"]
  }
}