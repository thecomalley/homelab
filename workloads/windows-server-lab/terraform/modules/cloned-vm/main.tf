resource "proxmox_vm_qemu" "main" {
  name                   = var.vm_name
  desc                   = var.description
  target_node            = "pve"
  agent                  = 1
  balloon                = 1024
  vmid                   = var.vm_id
  bios                   = "ovmf"
  boot                   = "order=scsi0;net0"
  cores                  = 2
  define_connection_info = false
  memory                 = 4096
  scsihw                 = "virtio-scsi-pci"
  clone                  = var.clone_from
  full_clone             = false
  tags                   = join(",", var.tags)

  disks {
    scsi {
      scsi0 {
        disk {
          cache   = "writeback"
          size    = "64G"
          storage = "nvme"
        }
      }
    }
  }

  network {
    bridge   = "vmbr0"
    firewall = false
    id       = 0
    tag      = 5 # VLAN 5
    model    = "virtio"
  }
}
