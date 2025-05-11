#cloud-config
autoinstall:
  version: 1
  locale: en_NZ
  keyboard:
    layout: us
  ssh:
    install-server: true
    allow-pw: true
    disable_root: true
    ssh_quiet_keygen: true
    allow_public_ssh_keys: true
  packages:
    - qemu-guest-agent
    - sudo
  storage:
    layout:
      name: direct
    swap:
      size: 0
  user-data:
    package_upgrade: false
    timezone: Pacific/Auckland
    users:
      - name: ${ssh_username}
        groups: [adm, sudo]
        lock-passwd: false
        sudo: ALL=(ALL) NOPASSWD:ALL
        shell: /bin/bash
        ssh_authorized_keys:
          - ${ssh_authorized_keys}
