# This script enables the OpenSSH Server feature on a Windows Server machine,
Get-WindowsCapability -Name OpenSSH.Server* -Online |
    Add-WindowsCapability -Online
Set-Service -Name sshd -StartupType Automatic -Status Running

# Create a firewall rule to allow inbound SSH traffic on TCP port 22
$firewallParams = @{
    Name        = 'sshd-Server-In-TCP'
    DisplayName = 'Inbound rule for OpenSSH Server (sshd) on TCP port 22'
    Action      = 'Allow'
    Direction   = 'Inbound'
    Enabled     = 'True'  # This is not a boolean but an enum
    Profile     = 'Any'
    Protocol    = 'TCP'
    LocalPort   = 22
}
New-NetFirewallRule @firewallParams

# Set the default shell for SSH sessions to PowerShell
$shellParams = @{
    Path         = 'HKLM:\SOFTWARE\OpenSSH'
    Name         = 'DefaultShell'
    Value        = 'C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe'
    PropertyType = 'String'
    Force        = $true
}
New-ItemProperty @shellParams

# Create the administrators_authorized_keys file and set permissions
New-Item -Path "$env:ProgramData\ssh\administrators_authorized_keys" -ItemType File -Force

# Write the public key to the administrators_authorized_keys file
Set-Content -Path "$env:ProgramData\ssh\administrators_authorized_keys" -Value "${publicKey}" -Force

# Set permissions for the administrators_authorized_keys file
icacls "$env:ProgramData\ssh\administrators_authorized_keys" /inheritance:r /grant "*S-1-5-32-544:F" /grant "SYSTEM:F"

# Restart the SSH service to apply changes
Restart-Service -Name sshd