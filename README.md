# Homelab

This repo contains the code I use for deploying and managing my home servers

| System         | Hardware | Purpose | Config Management |
| -------------- | -------- | ------- | ----------------- |
| Home Assistant | G2 Mini  |


## Ansible

1. Create a venv `python3.12 -m venv .ansible-venv`
2. Activate the venv `source .ansible-venv/bin/activate`
3. Upgrade pip `python3 -m pip install --upgrade pip`
4. install ansible `python3 -m pip install ansible`
5. Install dependencies required by the collection `pip3 install -r ~/.ansible/collections/ansible_collections/azure/azcollection/requirements.txt`

## Vault
encrypt: `ansible-vault encrypt ansible/pi/vars/secrets.yml`

Ansible playbooks primarily run on a schedule via [semaphore](https://github.com/semaphoreui/semaphore) 
but can also be run locally for testing & validation purposes

### PreReqs (local)
1. `ansible-galaxy install -r requirements.yml` 
2. `ansible-galaxy collection install community.docker`


### ansible/pi
1. `cd ansible/pi`
2. `ansible-vault decrypt vars/secrets.yml`
3. run `ansible-playbook -i hosts.yml playbook.yml` to deploy the pi


### ansible/g2-mini



## Authentication to hosts
1. Create a new ssh key pair on the semaphore container, `ssh-keygen` (may already exists in `~/.ssh/id_rsa`) if not 
2. From the semaphore container copy the public key to the host via `ssh-copy-id -i ~/.ssh/id_rsa.pub user@host`
3. Add the private key to the semaphore GUI under `Inventory` -> `User Authentication`


## Stopping Bad stuff
```
#!/bin/bash

# List of files to check
FILES=(
    "ansible/pi/vars/secrets.yml"
    "ansible/g2-mini/vars/secrets.yml"
)

# Encryption signature
ENCRYPTION_SIGNATURE="$ANSIBLE_VAULT;1.1;AES256"

# Check each file
for file in "${FILES[@]}"; do
    if [ -f "$file" ]; then
        first_line=$(head -n 1 "$file")
        if [[ "$first_line" != "$ENCRYPTION_SIGNATURE" ]]; then
            echo "$file is not encrypted!"
            exit 1
        fi
    fi
done
```