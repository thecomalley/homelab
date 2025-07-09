resource "local_file" "ansible_inventory" {
  filename = "${path.module}/ansible/inventory.yml"
  content = templatefile("${path.module}/ansible/inventory.yml.tpl", {
    unraid_hostname = var.unraid_hostname,
    unraid_username = var.unraid_username,
    services        = keys(var.apps)
  })
}

resource "terraform_data" "run_ansible" {
  triggers_replace = {
    always_run = "${timestamp()}"
  }
  provisioner "local-exec" {
    command = "ansible-playbook -i ${local_file.ansible_inventory.filename} ansible/playbook.yml"
  }
  depends_on = [local_file.ansible_inventory]
}
