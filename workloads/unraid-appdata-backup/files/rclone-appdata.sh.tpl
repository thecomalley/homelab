#!/bin/bash

# Variables
PING_URL=${ping_url}

echo "starting script"
curl -m 10 --retry 5 $PING_URL/start

# Copy the source to the destination. Doesn't transfer unchanged files. Doesn't delete files from the destination 
# Destination life cycle management is handled by the Azure Storage Account
cmd=$(rclone copy /mnt/user/backups/appdata azure-storage-account:appdata -v 2>&1)
exit_code=$?

echo "rclone exit_code = $exit_code"

# tell healthchecks job completed
curl -m 10 --retry 5 --data-raw "$cmd" $PING_URL/$exit_code
echo "script end"