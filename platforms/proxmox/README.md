# Proxmox Homelab Documentation

| **Host**          | **Hardware**             | **CPU**  | **RAM** | **NVMe** | **SSD**   |
| ----------------- | ------------------------ | -------- | ------- | -------- | --------- |
| pve01.proxmox.tld | HP EliteDesk 800 G2 Mini | i5 6500T | 32GB    | 256 GB   | 400GB SSD |
| pve02.proxmox.tld | HP EliteDesk 800 G2 Mini | i5 6500T | 8GB     | 256 GB   | 400GB SSD |


## Proxmox Installer Runbook
- Boot from Proxmox VE ISO (USB is lying around somewhere)
- Accept EULA
- Select target disk: /dev/nvme0n1
  - swapsize: 8 GB
  - maxroot: 32 GB
  - minfree: 4 GB
  - maxvz: *Leave blank to use all remaining space for VMs/*Containers*
- Configure Country/Time Zone/Keyboard
- Set root password and email
- Configure Network:

## Post-Install Runbook

### On Each Host
1. Run [Proxmox VE Post Install](https://community-scripts.github.io/ProxmoxVE/scripts?id=post-pve-install)
2. Rename the local-lvm to local-nvme
   1. `nano /etc/pve/storage.cfg` Change `local-lvm` to `local-nvme`
3. Provision the 400GB SSD as `local-ssd`
    1. `pvcreate /dev/sda`
    2. `vgcreate vg-ssd /dev/sda`
    3. `lvcreate -l 95%FREE -T vg-ssd/lv-ssd`
    4. `nano /etc/pve/storage.cfg` Add:
       ```
       lvmthin: local-ssd
           thinpool lv-ssd
           vgname vg-ssd
           content images,rootdir,iso,vztmpl
           maxfiles 5
       ```
4. Configure Cluster
5. on each node `apt install corosync-qdevice -y`

### Datacenter Tasks
1. `pvecm qdevice setup <pi-ip>` to set up quorum device
2. Configure NAS for shared NFS storage
3. Configure SSL settings, ACME, Let's Encrypt & Cloudflare DNS
4. Configure Notifications (See Below)

### Pushover Notifications (Webhook)

| Setting       | Value                                         |
| ------------- | --------------------------------------------- |
| Endpoint Name | Pushover                                      |
| Method/URL    | POST https://api.pushover.net/1/messages.json |
| Headers       | `Content-Type`: `application/json`            |
| Body          | *See below*                                   |
| Secrets       | apikey <br> userkey                           |
 
Body Template:
```json
{
  "token": "{{ secrets.apikey }}",
  "user": "{{ secrets.userkey }}",
  "title": "{{ title }}",
  "message": "{{ escape message }}",
  "priority": "0",
  "timestamp": "{{ timestamp }}"
}
```

## iGPU Passthrough for VMs (So Kids can play Minecraft :D)

- Ensure Intel VT-d & VT-x are enabled in BIOS
- Get device IDs: lspci -nn
  - pve01: 00:02.0 VGA compatible controller [0300]: Intel Corporation HD Graphics 530 [8086:1912] (rev 06)
  - pve02: 00:02.0 VGA compatible controller [0300]: Intel Corporation HD Graphics 530 [8086:1912] (rev 06)
- Enable IOMMU in GRUB
  - `nano /etc/default/grub`
  - `GRUB_CMDLINE_LINUX_DEFAULT="quiet intel_iommu=on iommu=pt"`
- Verify that IOMMU is enabled by running `dmesg | grep -e DMAR -e IOMMU` and looking for a line indicating it is enabled
