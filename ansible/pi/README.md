# ansible/pi

## Running Locally 

1. `cd ansible/pi`
2. `ansible-vault decrypt vars/secrets.yml`
3. run `ansible-playbook -i hosts.yml playbook.yml` to deploy the pi
