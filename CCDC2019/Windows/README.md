# CCDC2019


Seatbelt, Sharpup (Compiled for .NET 3.5)

PowerShellMafia PrivEsc scripts

Various Powershell Scripts(probably should compile into a single run script)


Disable Netbios:
```
$key = "HKLM:SYSTEM\CurrentControlSet\services\NetBT\Parameters\Interfaces" 
Get-ChildItem $key | 
foreach { Set-ItemProperty -Path "$key\$($_.pschildname)" -Name NetbiosOptions -Value 2 -Verbose} 
```

Query a registry key:
```
$key = "HKLM:SYSTEM\CurrentControlSet\services\NetBT\Parameters\Interfaces" 
Get-ChildItem $key | 
foreach { Get-ItemProperty -Path "$key\$($_.pschildname)" -Name NetbiosOptions}
```
