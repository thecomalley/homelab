# pidar 
> Raspberry Pi 3+

This system runs pi-hole and an ADS-B receiver

## Ansible - Running Locally 

1. `ansible-vault decrypt vars/secrets.yml`
2. run `ansible-playbook -i hosts.yml playbook.yml` to deploy the pi

## Ansible - Schedule

Runs on a schedule via [semaphore](https://github.com/semaphoreui/semaphore)
