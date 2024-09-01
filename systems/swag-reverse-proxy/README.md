# SWAG Proxy Configuration Playbook

This Ansible playbook is designed to configure [SWAG - Secure Web Application Gateway](https://github.com/linuxserver/docker-swag) proxy settings on an unRAID server. It either copies custom proxy configuration files from a local directory to the remote server or uses the samples provided with SWAG. It also updates DNS records accordingly.

## Requirements

* Environment variable `CLOUDFLARE_TOKEN` must be set 

## Variables

The following variables are used in this playbook:

* `cloudflare_zone`: The Cloudflare zone to update DNS records for (default: `malleynet.xyz`)
* `services`: A list of services to configure proxy settings for (default: `radarr`, `sonarr`, `frigate`)
* `remote_conf_path`: The path to the SWAG proxy configuration directory on the remote server (default: `/mnt/user/appdata/swag/nginx/proxy-confs`)
* `local_conf_path`: The path to the local directory containing custom proxy configuration files (default: `proxy-confs`)

## Tasks

This playbook performs the following tasks:

1. Checks if custom proxy configuration files exist for each service in the `services` list.
2. Copies custom proxy configuration files from the local directory to the remote server if they exist.

## Usage

To run this playbook, simply execute the following command:
```bash
ansible-playbook -i hosts.yml swag_proxy_conf.yml
```
Replace `hosts.yml` with the path to your Ansible inventory file.
