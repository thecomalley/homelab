# Secure Web Application Gateway (SWAG) 

This module configures the [Secure Web Application Gateway (SWAG)](https://docs.linuxserver.io/images/docker-swag/) reverse proxy for unRAID.

It allows the user to specify a list of applications to reverse proxy, and will create the necessary configurations for each application.

for each application, the module will:
- Create a Cloudflare DNS record for the application (terraform)
- Create a UptimeRobot monitor for the application (terraform)
- Create a reverse proxy configuration for the application from the swag {application}.subdomain.sample if available (ansible)

## Requirements

| Name                                                                            | Version   |
| ------------------------------------------------------------------------------- | --------- |
| <a name="requirement_ansible"></a> [ansible](#requirement\_ansible)             | 1.3.0     |
| <a name="requirement_cloudflare"></a> [cloudflare](#requirement\_cloudflare)    | 5.0.0-rc1 |
| <a name="requirement_uptimerobot"></a> [uptimerobot](#requirement\_uptimerobot) | 0.8.4     |

## Providers

| Name                                                                      | Version   |
| ------------------------------------------------------------------------- | --------- |
| <a name="provider_ansible"></a> [ansible](#provider\_ansible)             | 1.3.0     |
| <a name="provider_cloudflare"></a> [cloudflare](#provider\_cloudflare)    | 5.0.0-rc1 |
| <a name="provider_http"></a> [http](#provider\_http)                      | 3.4.5     |
| <a name="provider_uptimerobot"></a> [uptimerobot](#provider\_uptimerobot) | 0.8.4     |

## Modules

No modules.

## Resources

| Name                                                                                                                                         | Type        |
| -------------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| [ansible_playbook.playbook](https://registry.terraform.io/providers/ansible/ansible/1.3.0/docs/resources/playbook)                           | resource    |
| [cloudflare_dns_record.a](https://registry.terraform.io/providers/cloudflare/cloudflare/5.0.0-rc1/docs/resources/dns_record)                 | resource    |
| [uptimerobot_monitor.main](https://registry.terraform.io/providers/cogna-public/uptimerobot/0.8.4/docs/resources/monitor)                    | resource    |
| [http_http.onprem_ip](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http)                                  | data source |
| [uptimerobot_alert_contact.pushover](https://registry.terraform.io/providers/cogna-public/uptimerobot/0.8.4/docs/data-sources/alert_contact) | data source |

## Inputs

| Name                                                                                                        | Description                             | Type           | Default | Required |
| ----------------------------------------------------------------------------------------------------------- | --------------------------------------- | -------------- | ------- | :------: |
| <a name="input_apps"></a> [apps](#input\_apps)                                                              | A list of applications to reverse proxy | `list(string)` | n/a     |   yes    |
| <a name="input_azurerm_subscription_id"></a> [azurerm\_subscription\_id](#input\_azurerm\_subscription\_id) | The Azure subscription ID               | `any`          | n/a     |   yes    |
| <a name="input_cloudflare_api_token"></a> [cloudflare\_api\_token](#input\_cloudflare\_api\_token)          | The Cloudflare API token                | `string`       | n/a     |   yes    |
| <a name="input_cloudflare_zone_id"></a> [cloudflare\_zone\_id](#input\_cloudflare\_zone\_id)                | The Cloudflare zone ID                  | `string`       | n/a     |   yes    |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name)                                       | The domain name                         | `string`       | n/a     |   yes    |
| <a name="input_unraid_hostname"></a> [unraid\_hostname](#input\_unraid\_hostname)                           | The hostname of the Unraid server       | `string`       | n/a     |   yes    |
| <a name="input_uptimerobot_api_key"></a> [uptimerobot\_api\_key](#input\_uptimerobot\_api\_key)             | The UptimeRobot API key                 | `string`       | n/a     |   yes    |

## Outputs

No outputs.
