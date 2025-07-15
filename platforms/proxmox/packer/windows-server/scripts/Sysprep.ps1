# sysprep.ps1
# This script will generalize and shut down the Windows VM.

# Create a log file for debugging
$logFile = "C:\Windows\Temp\sysprep_log.txt"
Start-Transcript -Path $logFile -Append -Force

Write-Host "Starting Sysprep process at $(Get-Date)..."

# Verify unattend.xml exists
$unattendFile = "C:/Windows/Temp/sysprep_unattend.xml"
if (-not (Test-Path $unattendFile)) {
    Write-Warning "CRITICAL ERROR: unattend.xml not found at $unattendFile. Sysprep will fail!"
    Write-Host "Checking if the file was copied to another location..."
    $possibleLocations = @(
        "C:\Windows\Temp\sysprep_unattend.xml",
        "C:\Windows\System32\Sysprep\unattend.xml",
        "D:\sysprep_unattend.xml"
    )
    
    foreach ($location in $possibleLocations) {
        if (Test-Path $location) {
            Write-Host "Found unattend file at: $location"
            $unattendFile = $location
            break
        }
    }
}

# Display detailed system information for debugging
Write-Host "=== System Information ==="
Write-Host "Windows Version: $(Get-WmiObject -Class Win32_OperatingSystem | Select-Object -ExpandProperty Caption)"
Write-Host "Computer Name: $env:COMPUTERNAME"
Write-Host "Current Directory: $((Get-Location).Path)"
Write-Host "Unattend file path: $unattendFile"
Write-Host "Unattend file exists: $(Test-Path $unattendFile)"
if (Test-Path $unattendFile) {
    Write-Host "Unattend file size: $((Get-Item $unattendFile).Length) bytes"
}
Write-Host "==========================="

# Make sure we have the necessary permissions
try {
    Write-Host "Setting execution policy..."
    Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Force -Scope Process
} catch {
    Write-Warning "Could not set execution policy: $_"
}

# Run Sysprep with proper parameters and detailed error handling
Write-Host "Executing Sysprep command at $(Get-Date)..."
try {
    # Using Start-Process to capture exit code
    $sysprepProcess = Start-Process -FilePath "C:\Windows\System32\Sysprep\Sysprep.exe" `
        -ArgumentList "/generalize", "/oobe", "/shutdown", "/quiet", "/unattend:$unattendFile" `
        -Wait -PassThru -NoNewWindow
    
    $exitCode = $sysprepProcess.ExitCode
    Write-Host "Sysprep process completed with exit code: $exitCode"
    
    if ($exitCode -eq 0) {
        Write-Host "Sysprep executed successfully"
    } else {
        Write-Warning "Sysprep returned non-zero exit code: $exitCode"
        # Don't exit with error as Packer might need to continue
    }
} catch {
    Write-Error "Exception occurred while executing Sysprep: $($_.Exception.Message)"
    Write-Host "Stack trace: $($_.Exception.StackTrace)"
}

Write-Host "Sysprep script completed at $(Get-Date). System should shut down shortly."
Stop-Transcript