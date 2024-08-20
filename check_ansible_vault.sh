#!/bin/bash
# Check if any files don't have the Ansible Vault header

for file in "$@"; do
    if grep -q '^$ANSIBLE_VAULT' "$file"; then
        echo "Ansible Vault encryption detected in $file"
    else
        echo "Error: $file is not encrypted with Ansible Vault."
        echo "Run: ansible-vault encrypt $file"
        exit 1
    fi
done
