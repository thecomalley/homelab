# Ansible (via Terraform)

Boilerplate for running Ansible from Terraform.

## Running Standalone

- `inventory.yml` is excluded from git, so you'll need to create it yourself.
- `playbook.yml` is the Ansible playbook that will be run.

To run the playbook:
```bash
ansible-playbook -i inventory.yml playbook.yml
```

## Running from Terraform

- `ansible.tf` contains an [`ansible_playbook`](https://registry.terraform.io/providers/ansible/ansible/latest/docs/resources/playbook) resource that is responsible for running the Ansible playbook.

