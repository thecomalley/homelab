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
  node    = var.node
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
      "./files/virtio-win-guest-tools.exe",
      "./files/sysprep_unattend.xml",
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
  # vm_id                = var.vm_id
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
    script = "scripts/CreateAnsibleUser.ps1"
  }

  # Enable RDP
  provisioner "powershell" {
    name   = "EnableRDP"
    script = "scripts/EnableRDP.ps1"
  }

  # Install Windows Updates
  # provisioner "windows-update" {
  #   search_criteria = "IsInstalled=0"
  #   filters = [
  #     "exclude:$_.Title -like '*Preview*'",
  #     "include:$true",
  #   ]
  #   update_limit = 25
  # }

  # Copy the unattend.xml file to multiple locations to ensure it's found
  provisioner "file" {
    source      = "./files/sysprep_unattend.xml"
    destination = "C:/Windows/Temp/sysprep_unattend.xml"
  }
  
  # Copy to Sysprep directory as a backup location
  provisioner "powershell" {
    inline = [
      "Copy-Item -Path 'C:/Windows/Temp/sysprep_unattend.xml' -Destination 'C:/Windows/System32/Sysprep/unattend.xml' -Force",
      "Write-Host 'Unattend.xml has been copied to Sysprep directory'",
      "Get-ChildItem -Path 'C:/Windows/System32/Sysprep/unattend.xml' | Select-Object FullName, Length"
    ]
  }
  
  # Run diagnostics before Sysprep to verify system state
  provisioner "powershell" {
    inline = [
      "Write-Host '=== PRE-SYSPREP DIAGNOSTICS ==='",
      "Write-Host 'Checking Windows Ready for Sysprep:'",
      "Get-Service | Where-Object {$_.Name -like 'BITS' -or $_.Name -like 'wuauserv' -or $_.Name -like 'TrustedInstaller'} | Format-Table Name, Status",
      "Write-Host 'Checking for pending Windows updates:'",
      "$UpdateSession = New-Object -ComObject Microsoft.Update.Session",
      "$UpdateSearcher = $UpdateSession.CreateUpdateSearcher()",
      "$SearchResult = $UpdateSearcher.Search('IsInstalled=0')",
      "Write-Host \"Pending updates: $($SearchResult.Updates.Count)\"",
      "Write-Host 'Verifying Sysprep files:'",
      "Test-Path 'C:\\Windows\\System32\\Sysprep\\Sysprep.exe' -ErrorAction SilentlyContinue",
      "Write-Host 'Disk space:'",
      "Get-PSDrive -PSProvider FileSystem | Format-Table Name, Used, Free",
      "Write-Host '=== END PRE-SYSPREP DIAGNOSTICS ==='"
    ]
  }

  # Run Sysprep
  provisioner "powershell" {
    script           = "./scripts/Sysprep.ps1"
    # Allow more exit codes as success
    valid_exit_codes = [0, 1, 2300218, -1] # 2300218 is when Packer loses connection to the VM after Sysprep
    pause_before     = "10s" # Give the system a moment to prepare
    pause_after      = "180s" # Extended pause to ensure shutdown completes
    # Increase the default timeout
    timeout          = "15m"
  }
}