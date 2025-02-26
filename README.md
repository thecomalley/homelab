# Malleynet - Homelab

I maintain a personal repo for managing and deploying home servers, along with infrastructure monitoring and other services. Using Ansible and Terraform, I’ve automated the process and made it easier to manage everything. It’s my way of contributing to the Infrastructure as Code movement and staying up-to-date with modern practices in system administration.

- [Malleynet - Homelab](#malleynet---homelab)
  - [OnPrem](#onprem)
    - [Workloads](#workloads)

## OnPrem

| System                                 | Hardware              | Purpose                 | Automation |
| -------------------------------------- | --------------------- | ----------------------- | ---------- |
| Home Assistant                         | HP EliteDesk 800 Mini | Home Assistant...       |            |
| unRAID                                 | Old PC                | NAS + Media Server      |            |
| [pi](./ansible/pi/README.md)           | Raspberry Pi 3+       | pihole + ADS-B receiver | Ansible    |
| [g2-plex](./ansible/g2-plex/README.md) | HP EliteDesk 800 Mini | QuickSync Plex Server   | Ansible    |


### Workloads

| Workload Name           | Description | Cloud  | Link                                                   |
| ----------------------- | ----------- | ------ | ------------------------------------------------------ |
| Hour of Power Optimiser | Workload -  | Azure  | https://github.com/thecomalley/hour-of-power-optimiser |
| Azure Alert Parser      |             | Azure  | https://github.com/thecomalley/azure-alert-processor   |
| Plex                    |             | OnPrem |



esphome-heatpump-office