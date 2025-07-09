module "addc01" {
  source      = "./modules/cloned-vm"
  vm_name     = "win-dc01"
  description = "Active Directory Domain Controller"
  tags        = ["windows_domain_controller", "role-domain_controller"]
}

module "addc02" {
  source      = "./modules/cloned-vm"
  vm_name     = "win-dc02"
  description = "Active Directory Domain Controller"
  tags        = ["windows_domain_controller", "role-domain_controller"]
}

# module "mec01" {
#   source      = "./modules/cloned-vm"
#   vm_name     = "win-mec01"
#   description = "Microsoft Entra Connect Server"
#   tags        = ["windows_server", "role-entra_connect_server"]
# }

# module "mgmt01" {
#   source      = "./modules/cloned-vm"
#   vm_name     = "win-mgmt01"
#   description = "Management Server"
#   tags        = ["windows_server", "role-management_server"]
# }

# module "proxy01" {
#   source      = "./modules/cloned-vm"
#   vm_name     = "win-proxy01"
#   description = "Entra App Proxy Connector"
#   tags        = ["windows_server", "role-entra_app_proxy_connector"]
# }

# module "datagw01" {
#   source      = "./modules/cloned-vm"
#   vm_name     = "win-datagw01"
#   description = "On-Premises Data Gateway"
#   tags        = ["WindowsServer", "DataGateway"]
# }

# module "iis01" {
#   source      = "./modules/cloned-vm"
#   vm_name     = "win-iis01"
#   description = "IIS Web Server"
#   tags        = ["WindowsServer", "WebServer"]
# }

# module "sql01" {
#   source      = "./modules/cloned-vm"
#   vm_name     = "win-sql01"
#   description = "SQL Server"
#   tags        = ["WindowsServer", "SqlServer"]
# }

# module "ir01" {
#   source      = "./modules/cloned-vm"
#   vm_name     = "win-ir01"
#   description = "Self-Hosted Integration Runtime"
#   tags        = ["WindowsServer", "IntegrationRuntime"]
# }
