# Proxmox Packer Template for Ubuntu 24.04

This is a Packer template for creating a Proxmox VM template for Ubuntu Server 24.04. Its primary purpose is to pre-install

## Usage

1. Set environment variables
    ```sh
    PROXMOX_URL="https://<server>:<port>/api2/json"
    PROXMOX_USERNAME="root"
    PROXMOX_TOKEN="<token>"
    ```
2. Set variables in a  `variables.auto.pkrvars.hcl` file
    ```ruby
    proxmox_node = "pve"
    ssh_username = "your_username"
    ssh_authorized_keys = ["ssh-rsa AAAAB3Nz..."]
    ```
3. Run Packer
    ```sh
    packer build .
    ```