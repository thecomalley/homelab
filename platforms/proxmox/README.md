# Hybrid Windows Server Lab

Sometimes you just cant get away from Windows, the goal here is to ensure all Hybrid services that Microsoft provides are deployed into the lab environment, & since they all run on Windows Server we need some baseline Windows Server infra to support it (AD, DNS, DHCP, etc etc).

But fear not we are not giving into the light side (GUI) we can stay in dark mode and use Ansible to automate the and configuration of these servers, so we can still have a fully automated lab environment.



## Packer Tasks
| ✅   | Task                      | Handled By | Method     | Notes                         |
| --- | ------------------------- | ---------- | ---------- | ----------------------------- |
| ☐   | Enable RDP                | Packer     | PowerShell | Native via `Set-ItemProperty` |
| ☐   | Configure WinRM / OpenSSH | Packer     | PowerShell | Packer provisioning script    |





## 🛠️ Core Baseline Role

| ✅   | Task                           | Handled By | Method                                | Notes                        |
| --- | ------------------------------ | ---------- | ------------------------------------- | ---------------------------- |
| ☐   | Set hostname                   | Ansible    | `ansible.windows.win_hostname`        | Native Ansible               |
| ☐   | Set timezone                   | Ansible    | `ansible.windows.win_timezone`        | Native Ansible               |
| ☐   | Create Administrator User      | Ansible    | `ansible.windows.win_user`            | Use script to rename/disable |
| ☐   | Disable built-in Administrator | Ansible    | `ansible.windows.win_user`            | Use script to rename/disable |
| ☐   | Enable ICMP                    | Ansible    | `community.windows.win_firewall_rule` | Native Ansible               |
| ☐   | Install updates                | Ansible    | `ansible.windows.win_updates`         | Native Ansible               |
| ☐   | Remove SMBv1                   | Ansible    | `ansible.windows.win_feature`         | Native Ansible               |


| ☐   | Enable LAPS                          | Ansible (opt.)  | PowerShell                             | MS tool install + registry settings |
| ☐   | Set firewall rules                   | Ansible         | `community.windows.win_firewall_rule`  | Native Ansible                      |
| ☐   | Activate via KMS                     | Ansible         | PowerShell                             | `slmgr.vbs` or registry method      |
| ☐   | Install BGInfo                       | GPO (preferred) | PowerShell (fallback)                  | Script can copy & schedule          |
| ☐   | Configure NTP                        | Ansible         | PowerShell                             | No native module                    |
| ☐   | Update Defender defs/settings        | Ansible         | PowerShell                             | `Update-MpSignature` etc.           |
| ☐   | Set PowerShell execution policy      | Ansible         | `ansible.windows.win_shell`            | No native module (just shell)       |
| ☐   | Harden local admin group             | Ansible         | `ansible.windows.win_group_membership` | Native Ansible                      |
| ☐   | Configure pagefile                   | Ansible (opt.)  | PowerShell                             | WMI / registry changes              |
| ☐   | Run BPA for installed roles          | Ansible (opt.)  | PowerShell                             | Use `Invoke-BpaModel`               |
| ☐   | Export BPA results to file           | Ansible         | PowerShell                             | `Get-BpaResult` > file              |
| ☐   | Generate system info report          | Ansible         | PowerShell                             | CPU, RAM, OS, roles, IP, etc.       |
| ☐   | Copy report to central share/log     | Ansible         | `ansible.windows.win_copy`             | Native Ansible                      |
| ☐   | Install Azure Arc agent              | Ansible (opt.)  | PowerShell                             | Script with installer + config      |
| ☐   | Register with Arc                    | Ansible (opt.)  | PowerShell                             | Via onboarding script               |
| ☐   | Install & run AsBuiltReport          | Ansible (opt.)  | PowerShell                             | Install module, run report          |
| ☐   | Upload reports to SharePoint (Graph) | Ansible (opt.)  | PowerShell                             | Graph API + token                   |
| ☐   | Optimize performance                 | Ansible         | PowerShell                             | Disable services, adjust settings   |

## role Specific Tasks
| ☐   | Join domain                          | Ansible         | `ansible.windows.win_domain_membership` | Native Ansible                      |
