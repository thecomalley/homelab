# On-Prem

OnPrem contains 4 main components:

## unRAID

*This is my main NAS and host for most "Home Production" workloads, its simple easy to use and has a good uptime.*
|                  |                              |
| ---------------- | ---------------------------- |
| **Hardware**     | Custom build, (Sandy Bridge) |
| **Managed with** | Gui                          |

This repo doesn't contain much config for unRAID given its mostly configured via the GUI. however there are a couple little scripts and tools that I use to help manage the server.


## Home Assistant Operating System (HAOS)
|                  |                             |
| ---------------- | --------------------------- |
| **Hardware**     | HP EliteDesk 800 G2 Mini PC |
| **Managed with** | Gui                         |

Running on dedicated hardware this is the main host for any Home Automation workloads. This includes things like Home Assistant, Zigbee2MQTT, Esphome, etc.

Home Assistant is moving to a more GUI based configuration approach so this repo doesn't contain much in the way of config.

## ProxMox
|                  |                                |
| ---------------- | ------------------------------ |
| **Hardware**     | 1x HP EliteDesk 800 G2 Mini PC |
| **Managed with** | Terraform &                    |

Currently a single node, This is the main host for any "Home Development" workloads. This includes things like my homelab, dev environments, etc.

## K3s
|                  |                                     |
| ---------------- | ----------------------------------- |
| **Hardware**     | 1x Proxmox VM<br> 2x Raspberry Pi 5 |
| **Managed with** | ArgoCD                              |

This is my main Kubernetes cluster, it runs on the ProxMox host and is used for any "Home Development" workloads. This includes things like my homelab, dev environments, etc.