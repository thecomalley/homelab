# Windows Server 2025 is chaos and resource hungry so we will use 2022 for now
module "addc01" {
  source = "./modules/cloned-vm"

  vm_id       = 101
  vm_name     = "win-dc01"
  description = "Active Directory Domain Controller"

  target_node  = "pve01"
  storage_pool = "local-nvme"

  tags       = ["windows_domain_controller", "role-domain_controller"]
  clone_from = "windows-server-2022"
}

module "addc02" {
  source = "./modules/cloned-vm"

  vm_id       = 201
  vm_name     = "win-dc02"
  description = "Active Directory Domain Controller"
  clone_from  = "windows-server-2022"

  target_node  = "pve02"
  storage_pool = "local-nvme"

  tags = ["windows_domain_controller", "role-domain_controller"]
}

module "mgmt01" {
  source = "./modules/cloned-vm"

  vm_id       = 102
  vm_name     = "win-mgmt01"
  description = "Management Server"
  clone_from  = "windows-server-2022"

  target_node  = "pve01"
  storage_pool = "local-nvme"

  tags = ["windows_server", "role-management_server"]
}

module "mec01" {
  source = "./modules/cloned-vm"

  vm_id       = 103
  vm_name     = "win-sync01"
  description = "Microsoft Entra Connect Server"
  clone_from  = "windows-server-2022"

  target_node  = "pve01"
  storage_pool = "local-nvme"

  tags = ["windows_server", "role-entra_connect_server"]
}

# module "proxy01" {
#   source = "./modules/cloned-vm"

#   vm_id       = 104
#   vm_name     = "win-proxy01"
#   description = "Entra App Proxy Connector"
#   clone_from  = "windows-server-2022"

#   target_node  = "pve01"
#   storage_pool = "local-nvme"

#   tags = ["windows_server", "role-entra_app_proxy_connector"]
# }

module "ir01" {
  source = "./modules/cloned-vm"

  vm_id       = 105
  vm_name     = "win-ir01"
  description = "Self-Hosted Integration Runtime"
  clone_from  = "windows-server-2022"

  target_node  = "pve01"
  storage_pool = "local-nvme"

  tags = ["windows_server", "role-integration_runtime"]
}

# module "datagw01" {
#   source = "./modules/cloned-vm"

#   vm_id       = 106
#   vm_name     = "win-datagw01"
#   description = "On-Premises Data Gateway"
#   clone_from  = "windows-server-2022"

#   target_node  = "pve01"
#   storage_pool = "local-nvme"

#   tags = ["windows_server", "role-data_gateway"]
# }

# module "iis01" {
#   source = "./modules/cloned-vm"

#   vm_id       = 107
#   vm_name     = "win-iis01"
#   description = "IIS Web Server"
#   clone_from  = "windows-server-2022"

#   target_node  = "pve01"
#   storage_pool = "local-nvme"

#   tags = ["windows_server", "role-data_gateway"]
# }

module "sql01" {
  source = "./modules/cloned-vm"

  vm_id       = 108
  vm_name     = "win-sql01"
  description = "SQL Server"
  clone_from  = "windows-server-2022"

  target_node  = "pve01"
  storage_pool = "local-nvme"

  tags = ["windows_server", "role-sql_server"]
}

module "mig01" {
  source = "./modules/cloned-vm"

  vm_id       = 109
  vm_name     = "win-mig01"
  description = "Azure Migrate Appliance"

  target_node  = "pve01"
  storage_pool = "local-nvme"

  tags       = ["windows_server", "role-azure_migrate_appliance"]
  clone_from = "windows-server-2022"
}
