resource "ansible_playbook" "playbook" {
  playbook = "${path.module}/ansible/playbook.yml"
  name     = var.unraid_hostname

  extra_vars = {
    services_json = jsonencode(var.apps) # https://github.com/ansible/terraform-provider-ansible/issues/49
  }
}

# output "ansible_playbook_stderr" {
#   value = ansible_playbook.playbook.ansible_playbook_stderr
# }

# output "ansible_playbook_stdout" {
#   value = ansible_playbook.playbook.ansible_playbook_stdout
# }
