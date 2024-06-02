# Homelab
This repo contains the code I use for deploying and managing my home servers


## Ansible

### Pi

- run `ansible-playbook -i hosts.ini playbook.yml` to deploy the pi


## Authentication to hosts
1. Create a new ssh key pair on the semaphore container (likely already exists in `~/.ssh/id_rsa`)
2. From the semaphore container copy the public key to the host via `ssh-copy-id -i ~/.ssh/id_rsa.pub user@host`
3. Add the private key to the semaphore GUI under `Inventory` -> `User Authentication`