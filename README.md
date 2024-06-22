# Homelab
This repo contains the code I use for deploying and managing my home servers

## Ansible

Ansible playbooks primarily run on a schedule via [semaphore](https://github.com/semaphoreui/semaphore) 
but can also be run locally for testing & validation purposes

### PreReqs (local)
1. `ansible-galaxy install -r requirements.yml` 
2. `ansible-galaxy collection install community.docker`


### ansible/pi

1. run `ansible-playbook -i hosts.yml playbook.yml` to deploy the pi

### ansible/g2-mini

1. 

## Authentication to hosts
1. Create a new ssh key pair on the semaphore container (likely already exists in `~/.ssh/id_rsa`) if not 
2. From the semaphore container copy the public key to the host via `ssh-copy-id -i ~/.ssh/id_rsa.pub user@host`
3. Add the private key to the semaphore GUI under `Inventory` -> `User Authentication`