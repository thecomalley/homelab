---
mode: 'agent'
tools: ['githubRepo', 'codebase']
description: 'Write a Powershell Script to be called by an Ansible task'
---
Generate a PowerShell script that is suitable for execution as an Ansible task.
The script must be concise, efficient, and idempotent.
Ensure the script follows these Ansible integration rules:
    Use $Ansible variable to set Result, Changed, Failed, Diff, or access Tmpdir.
    Set $Ansible.Changed to true if changes are made, otherwise false.
    Set $Ansible.Failed to true to indicate failure.
    Use $Ansible.Result to return output to the controller.
    Use $Ansible.Diff for diff results (dictionary).
    Use $Ansible.Tmpdir for temporary files.
    Use $Ansible.Verbosity to adjust VerbosePreference/DebugPreference.

## Output types:
    - DateTime: ISO 8601 string in UTC.
    - DateTimeOffset: Include offset.
    - Enum: Dictionary with Type, String, Value.
    - Type: Dictionary with Name, FullName, AssemblyQualifiedName, BaseType.

- Avoid direct console output (Write-Host, [Console]::WriteLine), as it is returned as host_out or host_err.
- Output stream objects are returned as a list in output.
- The script should be compatible with Ansible check mode. If supporting check mode, use [CmdletBinding(SupportsShouldProcess)].
- Do not include unnecessary comments or explanations. Output only the script.
