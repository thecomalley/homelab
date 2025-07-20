`export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES`


## Check inventory is working
`ansible-inventory -i inventory.proxmox.yaml --list`

## Provision the Domain Controllers 
`ansible-playbook -i inventory.proxmox.yaml site.yaml`

## Configure the Member Servers
`ansible-playbook -i inventory.proxmox.yaml configure-windows-servers.yaml`


## Configure Only a specific server
`ansible-playbook -i inventory.proxmox.yaml configure-windows-servers.yaml --limit win-mgmt01`