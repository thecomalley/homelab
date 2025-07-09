# Physical Host Documentation

## Host Overview

| host  | hardware                    |
| ----- | --------------------------- |
| pve01 | HP EliteDesk 800 G2 Mini PC |

## New Host Setup

- [ ] Enable Notifications
- [ ] Configure Update Repos
- [ ] Configure DNS

### Notifications
Pushover can be configured via webhooks to send notifications.

- Method/URL: POST https://api.pushover.net/1/messages.json
- Content-Type: application/json​
  ```jsonc
  // Body
  {
    "token": "{{ secrets.apikey }}",
    "user": "{{ secrets.userkey }}",
    "title": "{{ title }}",
    "message": "{{ escape message }}",
    "priority": "0",
    "timestamp": "{{ timestamp }}"
  }
  ```

### Configure Repos
- https://community-scripts.github.io/ProxmoxVE/scripts?id=post-pve-install

### Configure DNS
- Add the host to the DNS server enabling reverse DNS lookups.
