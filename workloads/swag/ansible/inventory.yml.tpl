unRAID:
  hosts:
    ${unraid_hostname}:
      ansible_host: ${unraid_hostname}
      ansible_user: ${unraid_username}
      services:
    %{ for service in services ~}
      - ${service}
    %{ endfor ~}