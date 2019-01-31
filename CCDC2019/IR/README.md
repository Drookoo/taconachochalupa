# IR Tool Usage
## Get-SysmonViewLogs.ps1
Typical Usage:
```powershell
.\Get-SysmonViewLogs.ps1 -HostsFile .\hosts.txt -SysmonView
```
Options:
```
-HostsFile			File to specify hosts and credentials to be used
-SysmonView			Export logs into XML format readable by SysmonView
```
Hosts File Format:
```
[HOST]:[DOMAIN]:[USERNAME]:[PASSWORD]
```