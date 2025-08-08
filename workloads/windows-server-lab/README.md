# Windows Server Lab

Sometimes you just cant get away from Windows, the goal here is to ensure all Hybrid services that Microsoft provides are deployed into the lab environment, & since they all run on Windows Server we need some baseline Windows Server infra to support it (AD, DNS, DHCP, etc etc).

But fear not we are not giving into the light side (GUI) we can stay in dark mode and use Ansible to automate the and configuration of these servers, so we can still have a fully automated lab environment.

This repository contains a Windows Server lab setup using Terraform, Proxmox, and Ansible. It is designed to help you quickly set up a Windows Server environment for testing and development purposes.

## Server Inventory

| Server       | Role                                      |
| ------------ | ----------------------------------------- |
| win-dc01     | Active Directory Domain Controller        |
| win-dc02     | Active Directory Domain Controller        |
| win-sync01   | Microsoft Entra Connect                   |
| win-mgmt01   | Management Server                         |
| win-proxy01  | Microsoft Entra private network connector |
| win-datagw01 | On-Premises Data Gateway                  |
| win-iis01    | IIS Web Server                            |
| win-sql01    | SQL Server                                |
| win-ir01     | Self-Hosted Integration Runtime           |

## Architecture Overview

This lab provides a complete Windows Server environment with Active Directory Domain Services and various server roles. It's designed to simulate a production environment for testing, development, and learning purposes.

- **Active Directory**: Two domain controllers for redundancy and testing multi-DC scenarios
- **Microsoft Entra Integration**: Server for synchronizing on-premises AD with Microsoft Entra ID (formerly Azure AD)
- **Management Capabilities**: Dedicated management server for administrative tasks
- **Application Infrastructure**: Web servers, SQL database, and integration services

## Prerequisites

- [Proxmox](https://www.proxmox.com/) environment
- [Terraform](https://www.terraform.io/) (v1.0.0+)
- [Ansible](https://www.ansible.com/) (v2.12.0+)
- Windows Server 2022 template in Proxmox (named "windows-server-2022-desktop")

### Required Terraform Provider

```bash
terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.1-rc8"
    }
  }
}
```

## Deployment Instructions

### 1. Infrastructure Deployment with Terraform

Navigate to the terraform directory and initialize the environment:

```bash
cd terraform
terraform init
```

Create and review the execution plan:

```bash
terraform plan
```

Apply the configuration to create the virtual machines:

```bash
terraform apply
```

### 2. Server Configuration with Ansible

For macOS users, you may need to set the following environment variable to prevent fork-related issues:

```bash
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
```

Verify your inventory configuration:

```bash
cd ../ansible
ansible-inventory -i inventory.proxmox.yaml --list
```

Configure the domain controllers:

```bash
ansible-playbook -i inventory.proxmox.yaml domain-controllers.yaml
```

Deploy the full environment:

```bash
ansible-playbook -i inventory.proxmox.yaml site.yaml
```

## Directory Structure

- **terraform/** - Contains Terraform configuration files for VM provisioning
  - **modules/** - Reusable Terraform modules
  - **main.tf** - Main Terraform configuration
  - **main.win.tf** - Windows VM configurations
  - **provider.tf** - Provider configurations
- **ansible/** - Ansible playbooks and configurations
  - **roles/** - Role-specific configurations
  - **host_vars/** - Host-specific variables
  - **vars/** - Shared variables
  - **domain-controllers.yaml** - Domain controller setup playbook
  - **site.yaml** - Main playbook for full environment setup

## VM Specifications

Each VM is configured with the following default specifications (customizable through Terraform variables):

- **CPU**: 2 cores
- **RAM**: 4GB
- **Disk**: 64GB
- **Network**: Bridged to vmbr0
- **OS**: Windows Server 2022 (Desktop Experience)

## Customization

You can customize the deployment by:

1. Modifying the VM specifications in `terraform/modules/cloned-vm/main.tf`
2. Updating role-specific configurations in the Ansible roles
3. Uncommenting additional servers in `main.win.tf` to deploy more components

## Troubleshooting

- If you encounter connectivity issues with the VMs, verify network settings in Proxmox
- For Ansible authentication issues, check the credentials in your inventory file
- Domain controller promotion issues might require checking DNS settings

## Contributing

Contributions to improve the lab setup are welcome. Please feel free to submit pull requests or open issues for any bugs or feature requests.

## License

This project is licensed under the terms of the included LICENSE file.