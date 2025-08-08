`export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES`

## Check inventory is working
`ansible-inventory -i inventory.proxmox.yaml --list`

## Run the Playbooks
`ansible-playbook -i inventory.proxmox.yaml site.yaml`


### Provision the Domain Controllers 
`ansible-playbook -i inventory.proxmox.yaml configure-windows-servers.yaml --limit proxmox_windows_domain_controller`

### Configure Only a specific server
`ansible-playbook -i inventory.proxmox.yaml site.yaml --limit win-ir01`


### 