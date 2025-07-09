`export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES`


## Check inventory is working
`ansible-inventory -i inventory.proxmox.yaml --list`

## Provision the Domain Controllers 
`ansible-playbook -i inventory.proxmox.yaml domain-controllers.yaml`
