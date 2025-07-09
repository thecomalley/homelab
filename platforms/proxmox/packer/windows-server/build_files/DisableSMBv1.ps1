# Disable SMBv1
Set-SmbServerConfiguration -EnableSMB1Protocol $false -Force