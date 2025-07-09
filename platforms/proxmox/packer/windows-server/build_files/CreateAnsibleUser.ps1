$User = "ansible"

# Generate a secure random password using built-in PowerShell functionality
$PasswordLength = 16
$RandomPassword = -join ((33..126) | Get-Random -Count $PasswordLength | ForEach-Object { [char]$_ })
Write-Output "Generated random password for user '$User'. This password will be reset later."
$Password = ConvertTo-SecureString $RandomPassword -AsPlainText -Force

# Check if user already exists
$UserExists = Get-LocalUser -Name $User -ErrorAction SilentlyContinue

if ($UserExists -eq $null) {
    # Create the user if it does not exist
    try {
        New-LocalUser -Name $User -Password $Password -FullName "Ansible Admin" -Description "Admin for automation" -ErrorAction Stop
        Write-Output "Created user '$User' successfully"
        
        # Add user to Administrators group
        try {
            Add-LocalGroupMember -Group "Administrators" -Member $User -ErrorAction Stop
            Write-Output "Added user '$User' to Administrators group"
        } catch {
            Write-Output "Failed to add user to Administrators group: $_"
        }
    } catch {
        Write-Output "Failed to create user: $_"
    }
} else {
    Write-Output "User '$User' already exists"
    
    # Ensure user is in Administrators group
    try {
        $InAdminGroup = Get-LocalGroupMember -Group "Administrators" -Member $User -ErrorAction SilentlyContinue
        if (-not $InAdminGroup) {
            Add-LocalGroupMember -Group "Administrators" -Member $User
            Write-Output "Added existing user '$User' to Administrators group"
        } else {
            Write-Output "User '$User' is already in Administrators group"
        }
    } catch {
        Write-Output "Error checking/updating group membership: $_"
    }
}
