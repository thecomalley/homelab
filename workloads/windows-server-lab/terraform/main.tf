# TODO: make this a module and write a post about modules?
resource "proxmox_vm_qemu" "k3s01" {

  name = "k3s01"
  desc = "K3S Cluster Node 01"

  vmid        = "100"
  target_node = "pve"

  clone = "template-ubuntu-server-24-04"

  # VM Specs
  cores   = 2
  sockets = 1
  memory  = 4096 # The amount of memory to allocate to the VM in Megabytes.
  balloon = 1024 # The minimum amount of memory to allocate to the VM in Megabytes.

  full_clone = false
  agent      = 1 # <-- (Optional) Enable QEMU Guest Agent

  onboot = true

  # NOTE Change startup, shutdown and auto reboot behavior
  startup          = ""
  automatic_reboot = false

  qemu_os  = "other"
  bios     = "seabios"
  cpu_type = "host"

  # !SECTION

  # SECTION Network Settings

  network {
    id     = 0 # NOTE Required since 3.x.x
    bridge = "vmbr0"
    model  = "virtio"
    tag    = 4 # vlan tag
  }

  # !SECTION

  # SECTION Disk Settings

  # NOTE Change the SCSI controller type, since Proxmox 7.3, virtio-scsi-single is the default one         
  scsihw = "virtio-scsi-single"

  # NOTE New disk layout (changed in 3.x.x)
  disks {
    ide {
      ide0 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }

    virtio {
      virtio0 {
        disk {
          storage = "nvme"

          # NOTE Since 3.x.x size change disk size will trigger a disk resize
          size = "20G"

          # NOTE Enable IOThread for better disk performance in virtio-scsi-single
          #      and enable disk replication
          iothread  = true
          replicate = false
        }
      }
    }
  }

  ipconfig0 = "ip=10.1.4.10/32,gw=10.1.4.1"
  # nameserver = "0.0.0.0"
  ciuser = "omadmin"

  # !SECTION
}
