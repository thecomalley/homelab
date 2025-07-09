# Proxmox Homelab Documentation

This document serves as both reference and as-built documentation for the Proxmox Virtual Environment (PVE) implementation in the homelab.

## Environment Overview

### Current Infrastructure

| **Host** | **Hardware**             | **CPU** | **RAM** | **Storage** | **IP Address** | **Role** |
| -------- | ------------------------ | ------- | ------- | ----------- | -------------- | -------- |
| pve01    | HP EliteDesk 800 G2 Mini | 4 cores | 16GB    | 500GB SSD   | 192.168.1.x    | Host     |

## Datacenter Configuration

### Completed Tasks
- [x] Configure Metric Server to point to InfluxDB (Grafana for visualization)

### Pending Tasks
- [ ] Configure a Cluster (Pending additional hosts)
- [ ] Configure High Availability (Pending additional hosts)
- [ ] Implement central storage solution

## New Host Setup

### Initial Configuration Checklist
- [ ] Update firmware/BIOS to latest version
- [ ] Install Proxmox VE (latest stable version)
- [ ] Configure network settings
- [ ] Enable Notifications
- [ ] Configure Update Repositories
- [ ] Configure DNS settings
- [ ] Integrate with backup solution

### Notifications Setup
Pushover is used for system notifications via webhooks:

**Configuration Details:**
- **Method/URL:** POST https://api.pushover.net/1/messages.json
- **Content-Type:** application/json

**Request Body Template:**
```json
{
  "token": "{{ secrets.apikey }}",
  "user": "{{ secrets.userkey }}",
  "title": "{{ title }}",
  "message": "{{ escape message }}",
  "priority": "0",
  "timestamp": "{{ timestamp }}"
}
```

### Repository Configuration
1. Enterprise repository should be disabled unless subscription is active
2. Configure no-subscription repository:
   - Follow instructions at: https://community-scripts.github.io/ProxmoxVE/scripts?id=post-pve-install
3. Add the pve-no-subscription repo for updates

### DNS Configuration
- Add the host to the DNS server with both forward and reverse lookups
- Ensure hostname resolution works correctly within the network
- Recommended: Set up a dedicated DNS record for Proxmox web interface
