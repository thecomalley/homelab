# Rsync to Blob Storage

This is a small Terraform module to deploy an Azure Blob Storage account and a Script to rsync the unRAID Backup dir to blob storage, It also includes the deployment of [healthcecks.io](https://healthchecks.io/) monitors for cron jobs.

## Requirements
- unRAID Plugins
  - [Appdata.Backup](https://forums.unraid.net/topic/137710-plugin-appdatabackup/)
  - [rclone](https://forums.unraid.net/topic/51633-plugin-rclone/)

## Deployment Steps
1. Deploy terraform stack, this repo uses Terraform Cloud
2. unRAID config
   1. Copy the contents of `UserScripts/rclone.conf` to the rclone config in the unRAID settings GUI, replacing the variables with the values from the terraform output
   2. Copy the contents of `UserScripts/rclone-appdata.sh` to the rclone-appdata script in the unRAID settings GUI, again replacing the variables with the values from the terraform output
3. Test the backup by running the rclone-appdata script in the unRAID settings GUI