# Raspberry Pi 3 Model B (rpi3b)

## Overview
- **Environment:** Home-Prod
- **Hardware:** Raspberry Pi 3 Model B
- **Managed with:** Ansible
- **Key Workloads:** DNS, Flight Tracker

## Description
This is a standalone Raspberry Pi 3 Model B that is used to run a few services. It's too low powered to be a part of the k3s cluster but can manage DNS and has a USB RTL-SDR attached to it for flight monitoring.

## Ansible Configuration

### Running Locally
1. Run Ansible: `ansible-playbook -i hosts.yml playbook.yml`