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

  # BuildFiles | maps to D:\
  additional_iso_files {
    iso_storage_pool = var.iso_storage_pool
    unmount          = true
    cd_label         = "BuildFiles"
    cd_files = [
      "./drivers/*",
      "./files/virtio-win-guest-tools.exe",
      "./files/virtio-win-gt-x64.msi",
      "./files/unattend.xml",
      "./files/sysprep.bat",
    ]
    # Generate some files with values provided by Packer
    cd_content = {

      # The Autounattend.xml file is used for unattended installation of Windows
      "Autounattend.xml" = templatefile("./templates/Autounattend.xml.pkrtpl", {
        ImageName             = var.image_name,
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

  # Reboot the VM
  provisioner "windows-restart" {
  }

  # CreateAnsibleUser
  provisioner "powershell" {
    name        = "CreateAnsibleUser"
    script      = "scripts/CreateAnsibleUser.ps1"
    pause_after = "30s"
    debug_mode  = 1
  }

  # Enable RDP
  provisioner "powershell" {
    name        = "EnableRDP"
    script      = "scripts/EnableRDP.ps1"
    pause_after = "30s"
    debug_mode  = 1
  }

  # Install Windows Updates
  provisioner "windows-update" {
    search_criteria = "IsInstalled=0"
    filters = [
      "exclude:$_.Title -like '*Preview*'",
      "include:$true",
    ]
    update_limit = 25
  }

  # Copy the unattend.xml file to the VM
  provisioner "file" {
    source = "./build_files/unattend.xml"
    destination = "C:/Windows/Temp/unattend.xml"
  }



  # Run Sysprep
  provisioner "powershell" {
    script = "./build_files/Sysprep.ps1"
    valid_exit_codes = [0, 2300218] # 2300218 is a code when Packer looses connection to the VM after Sysprep
    pause_after = "120s"
  }

  provisioner "file" {
    destination = "C:\\Windows\\System32\\Sysprep\\unattend.xml"
    source      = "${var.sysprep_unattended}"
  }

  provisioner "powershell" {
    inline = ["Write-Output Phase-5-Deprovisioning", "if (!(Test-Path -Path $Env:SystemRoot\\system32\\Sysprep\\unattend.xml)){ Write-Output 'No file';exit (10)}", "& $Env:SystemRoot\\System32\\Sysprep\\Sysprep.exe /oobe /generalize /quit /quiet /unattend:C:\\Windows\\system32\\sysprep\\unattend.xml"]
  }

}