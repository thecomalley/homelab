# G2-Plex 
> HP EliteDesk 800 Mini

This system runs plex standalone from the NAS primarily to leverage QuickSync for transcoding

## Ansible - Running Locally 

1. `ansible-vault decrypt vars/secrets.yml`
2. run `ansible-playbook -i hosts.yml playbook.yml --ask-become-pass` 

## Ansible - Schedule

Runs on a schedule via [semaphore](https://github.com/semaphoreui/semaphore)
