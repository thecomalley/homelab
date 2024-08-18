# ansible/g2-mini

## Running Locally 

1. `cd ansible/g2-mini`
2. `ansible-vault decrypt vars/secrets.yml`
3. run `ansible-playbook -i hosts.yml playbook.yml` to deploy the pi
