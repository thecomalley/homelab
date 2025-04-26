unRAID:
  hosts:
    ${unraid_hostname}:
      ansible_host: ${unraid_hostname}
      services:
    %{ for app in services ~}
      - ${app}
    %{ endfor ~}