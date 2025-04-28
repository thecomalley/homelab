## K3s

|                  |                                     |
| ---------------- | ----------------------------------- |
| **Hardware**     | 1x Proxmox VM<br> 2x Raspberry Pi 5 |
| **Managed with** | ArgoCD                              |

This is my main Kubernetes cluster, it runs on the ProxMox host and is used for any "Home Development" workloads. This includes things like my homelab, dev environments, etc.

# k3s - Kubernetes!

Yes we are running Kubernetes in my Homelab, its way overkill but its not production so I can do what I want.

## Nodes

We are using 
- 1x Server Node (ProxMox VM) 
- 2x Worker Nodes (Raspberry Pi 5s), 

*It's a weird setup i know but its what I have available, long term i'd like to get a few more servers and run a proper cluster but for now this works.*

## Bootstrapping

Bootstrapping is done via Techno Tim's [k3s-ansible](https://github.com/techno-tim/k3s-ansible) playbook. Its not included in this repo because git-submodules are a nightmare and I don't want to deal with them.


