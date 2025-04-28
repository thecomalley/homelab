## ProxMox
|                  |                                |
| ---------------- | ------------------------------ |
| **Hardware**     | 1x HP EliteDesk 800 G2 Mini PC |
| **Managed with** | Terraform &                    |

Currently a single node, This is the main host for any "Home Development" workloads. This includes things like my homelab, dev environments, etc.




# Pushover Config

Have webhooks working on pushover.
Method: POST
URL: https://api.pushover.net/1/messages.json
Headers:
Key: Content-Type Value: application/json​
Body:

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