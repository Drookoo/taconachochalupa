# . .\Get-SysmonLogs.ps1 -ComputerName 192.168.9.10 -Credential Administrator

# Optional parameters to get events from remote host
param (
    [Parameter(Position = 0, Mandatory = $False)]
    [string]
    $ComputerName,
    [Parameter(Position = 1, Mandatory = $False)]
    [System.Management.Automation.PSCredential]
    $Credential
)

# Get-WinEvent Parameters
$WinEventParameters = @{ 'Oldest' = $True }
if($ComputerName) { $WinEventParameters['ComputerName'] = $ComputerName }
if($Credential) { $WinEventParameters['Credential'] = $Credential }

# FilterHashtable Argument Array
$WinEventFilters = @{ 'LogName' = 'Microsoft-Windows-Sysmon/Operational' }

# Check if events were already imported
if($Events) {
    $DATE = $Events | Select -Last 1 | %{ $_.TimeCreated }
    $DATE
    $WinEventFilters['StartTime'] = $DATE
}
else {
    echo "No log history..."
    $SplitEvents = @()
}

$WinEventParameters['FilterHashtable'] = $WinEventFilters

$Events = Get-WinEvent @WinEventParameters -MaxEvents 500

$Events | ForEach-Object {
  $Lines = $_.Message –split [System.Environment]::NewLine
  $Id = $_.Id
  $TimeCreated = $_.TimeCreated
  $EventName = $Lines[0] –replace ‘:’
  $Event = New-Object PSObject
  $Event | Add-Member -MemberType ‘NoteProperty’ –Name ‘Id’ –Value $Id
  $Event | Add-Member –MemberType ‘NoteProperty’ –Name ‘EventName’ –Value $EventName
  $Event | Add-Member –MemberType ‘NoteProperty’ –Name ‘TimeCreated’ –Value $TimeCreated
  $Lines | Select-Object –Skip 1 | ForEach-Object {
    $PropName,$PropValue = $_ -split ‘: ’
    $PropName = $PropName –replace ‘ ’
    Add-Member –InputObject $Event –MemberType NoteProperty –Name $PropName –Value $PropValue
  }
  $SplitEvents += $Event
}