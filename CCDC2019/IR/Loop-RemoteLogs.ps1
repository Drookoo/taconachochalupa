# . .\Loop-RemoteLogs.ps1 -ComputerName 192.168.9.10 -FilePath C:\Users\Public\Documents\IR\Logs\DC_logs.xml

param (
    [Parameter(Position = 0, Mandatory = $True)]
    [string]
    $ComputerName,
    [Parameter(Position = 1, Mandatory = $True)]
    [string]
    $FilePath
)

$Cred = Get-Credential

$global:Events = $null
$global:SplitEvents = $null


while($true) {
    if($Events) {
        $DATE = $Events | Select -Last 1 | %{ $_.TimeCreated }
        echo Latest Log: $DATE
        $WinEventFilters['StartTime'] = $DATE
    }
    else {
        echo "No log history..."
        $SplitEvents = @()
    }
    
    $Events = Get-WinEvent -LogName Microsoft-Windows-Sysmon/Operational -ComputerName $ComputerName -Credential $Cred -Oldest
    
    $Events | ForEach-Object {
            $Lines = $_.Message –split [System.Environment]::NewLine
            $Id = $_.Id
            $EventName = $Lines[0] –replace ‘:’
            $Event = New-Object PSObject
            $Event | Add-Member -MemberType ‘NoteProperty’ –Name ‘Id’ –Value $Id
            $Event | Add-Member –MemberType ‘NoteProperty’ –Name ‘EventName’ –Value $EventName
            $Lines | Select-Object –Skip 1 | ForEach-Object {
            $PropName,$PropValue = $_ -split ‘: ’
            $PropName = $PropName –replace ‘ ’
            Add-Member –InputObject $Event –MemberType NoteProperty –Name $PropName –Value $PropValue
        }
        $SplitEvents += $Event
    }

    Write-Host Pulled $Events.count events

    $SplitEvents | Export-Clixml $FilePath

    Start-Sleep (60*1)  # pull every X minutes
}