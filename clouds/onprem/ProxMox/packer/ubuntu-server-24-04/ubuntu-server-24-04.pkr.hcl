packer {
  required_plugins {
    proxmox = {
      version = "~> 1.0"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

# Create a local variable with the templated user-data
locals {
  user_data = templatefile("${path.root}/files/user-data.pkrtpl.hcl", {
    ssh_username        = var.ssh_username
    ssh_authorized_keys = join("\n", var.ssh_authorized_keys)
  })
}

# Resource Definition for the VM Template
source "proxmox-iso" "ubuntu-server-noble" {

  insecure_skip_tls_verify = true
  node                     = var.proxmox_node

  # VM General Settings
  vm_id   = "800"
  vm_name = "ubuntu-server-noble"

  template_name        = "template-ubuntu-server-24-04"
  template_description = "Created by Packer on ${timestamp()}"

  # VM OS Settings
  boot_iso {
    type             = "scsi"
    iso_file         = "local:iso/ubuntu-24.04.2-live-server-amd64.iso"
    iso_storage_pool = "local"
    unmount          = true
  }

  # VM System Settings
  qemu_agent = true

  # VM Hard Disk Settings
  scsi_controller = "virtio-scsi-pci"

  disks {
    disk_size    = "20G"
    format       = "raw"
    storage_pool = "local-lvm"
    type         = "virtio"
  }

  # VM CPU Settings
  cores = "1"

  # VM Memory Settings
  memory = "2048"

  # VM Network Settings
  network_adapters {
    model    = "virtio"
    bridge   = "vmbr0"
    firewall = "false"
  }

  # VM Cloud-Init Settings
  cloud_init              = true
  cloud_init_storage_pool = "local-lvm"

  # The time to wait after booting the initial virtual machine before typing the boot_command
  boot_wait = "10s"

  # Escape the GUI installer and use the autoinstall method
  boot_command = [
    "<esc><wait>",
    "e<wait>",
    "<down><down><down><end>",
    "<bs><bs><bs><bs><wait>",
    "autoinstall ds=nocloud-net\\;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/ ---<wait>",
    "<f10><wait>"
  ]

  # Provide content to the autoinstall Server
  http_content = {
    "/user-data" = local.user_data
    "/meta-data" = file("${path.root}/files/meta-data")
  }

  communicator         = "ssh"
  ssh_username         = var.ssh_username
  ssh_private_key_file = "~/.ssh/id_rsa"

  # Raise the timeout, when installation takes longer
  ssh_timeout = "30m"
  ssh_pty     = true
}

# Build Definition to create the VM Template
build {
  name    = "ubuntu-server-24-04"
  sources = ["source.proxmox-iso.ubuntu-server-noble"]

  # Prepare the image for generalization
  provisioner "shell" {
    inline = [
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done",
      "sudo rm /etc/ssh/ssh_host_*",
      "sudo truncate -s 0 /etc/machine-id",
      "sudo apt -y autoremove --purge",
      "sudo apt -y clean",
      "sudo apt -y autoclean",
      "sudo cloud-init clean",
      "sudo rm -f /etc/cloud/cloud.cfg.d/subiquity-disable-cloudinit-networking.cfg",
      "sudo rm -f /etc/netplan/00-installer-config.yaml",
      "sudo sync"
    ]
  }

  # Copy the cloud-init datasource override file to the VM
  provisioner "file" {
    source      = "files/99-pve.cfg"
    destination = "/tmp/99-pve.cfg"
  }

  # Move the cloud-init the cloud-init datasource override file to the correct location
  provisioner "shell" {
    inline = ["sudo cp /tmp/99-pve.cfg /etc/cloud/cloud.cfg.d/99-pve.cfg"]
  }
}