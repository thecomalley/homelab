# Windows Server Templates for Proxmox

This repository contains Packer configurations for creating Windows Server VM templates in Proxmox. Currently supports:

- Windows Server 2022
- Windows Server 2025

## Overview

These Packer configurations automate the process of creating fully configured Windows Server VM templates in Proxmox. The templates are pre-configured with:

- VirtIO drivers for optimal performance
- QEMU Guest Agent
- SSH enabled with public key authentication
- WinRM configured
- Remote Desktop enabled
- Standard user account for Ansible automation
- Sysprep'd for template deployment

## Prerequisites

- [Packer](https://www.packer.io/downloads) (v1.7.0 or later)
- [Proxmox VE](https://www.proxmox.com/en/proxmox-ve) (v7.0 or later)
- Windows Server ISO files:
  - Windows Server 2022: `en-us_windows_server_2022_updated_april_2025_x64_dvd_3f755ec1.iso`
  - Windows Server 2025: `en-us_windows_server_2025_updated_april_2025_x64_dvd_ea86301d.iso`
- VirtIO drivers (download from [Fedora](https://fedorapeople.org/groups/virt/virtio-win/direct-downloads/archive-virtio/))

## Setup

1. Clone this repository
2. Download the required Windows Server ISOs and place them in your Proxmox ISO storage
3. Download and extract VirtIO drivers to the `drivers` directory (see [drivers/README.md](drivers/README.md))
4. Download and place the installers in the `installers` directory (see [installers/README.md](installers/README.md))
5. Create a `.env` file with your Proxmox credentials (use the sample as a guide)
6. Configure variables in the respective `*.auto.pkrvars.hcl` files

## Build Process

The build process for both Windows Server versions follows these steps:

1. **VM Creation**: Creates a new VM in Proxmox with UEFI boot and VirtIO devices
2. **OS Installation**: 
   - Boots from the Windows Server ISO
   - Uses `Autounattend.xml` to automate the installation
   - Injects the VirtIO drivers for storage and network
   - Sets up initial administrator account

3. **First Boot Configuration**:
   - Runs `bootstrap.ps1` to configure initial settings
   - Installs VirtIO drivers and QEMU Guest Agent
   - Configures networking for the VM

4. **System Configuration**:
   - Restarts the VM after initial setup
   - Configures SSH with public key authentication
   - Creates an Ansible user account
   - Enables and configures WinRM
   - Enables Remote Desktop

5. **Finalization**:
   - Runs Sysprep with a custom unattend.xml file
   - Generalizes the system for template creation
   - Shuts down the VM for template conversion

6. **Template Creation**:
   - Converts the VM to a template in Proxmox
   - Ready for deployment with unique SIDs

## Usage

To build a Windows Server 2022 template:

```bash
cd windows-server-2022
packer init .
packer build .
```

To build a Windows Server 2025 template:

```bash
cd windows-server-2025
packer init .
packer build .
```

## Customization

Adjust the following files to customize your builds:

- [`windows-server-2022/variables.auto.pkrvars.hcl`](windows-server-2022/variables.auto.pkrvars.hcl): VM settings, ISO paths, credentials
- [`files/2022/Autounattend.xml.pkrtpl`](files/2022/Autounattend.xml.pkrtpl): Installation settings
- `scripts/*.ps1`: Customization scripts
- `templates/*.ps1`: Template scripts with variable injection

## Notes

- The build process takes anywhere from 15-60 minutes depending on your hardware
- Windows updates are currently disabled in the configuration as they have been causing build failures
- UEFI boot is required for Windows Server 2025
- Secure Boot and TPM are configured for Windows Server 2025

## Directory Structure

- [`drivers`](drivers): VirtIO drivers for Windows
- [`files`](files): Unattend XML files for Windows installation
- [`installers`](installers): MSI installers for VirtIO and QEMU Guest Agent
- [`scripts`](scripts): PowerShell scripts for VM configuration
- [`templates`](templates): Template files with variable placeholders
- [`windows-server-2022`](windows-server-2022): Packer files for Windows Server 2022
- [`windows-server-2025`](windows-server-2025): Packer files for Windows Server 2025

## Credits

- https://github.com/EnsoIT/packer-windows-proxmox
- https://github.com/marcinbojko/proxmox-kvm-packer