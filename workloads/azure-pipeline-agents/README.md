# Azure Pipelines agents

The Azure Pipeline agents are deployed onto two platforms
- Azure using the [Azure Verified Module for Azure DevOps Agents and GitHub Runners](https://registry.terraform.io/modules/Azure/avm-ptn-cicd-agents-and-runners/azurerm/latest) as Azure Container App Jobs

- Proxmox as Ubuntu VMs using Terraform & Ansible