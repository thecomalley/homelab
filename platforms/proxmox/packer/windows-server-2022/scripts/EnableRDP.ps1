# Enable Remote Desktop Protocol (RDP)
New-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Terminal Server" -name fDenyTSConnections -PropertyType DWORD -Value 0 -Force

# Enable the Remote Desktop firewall rule
netsh advfirewall firewall add rule name="Open Port 3389" dir=in action=allow protocol=TCP localport=3389
