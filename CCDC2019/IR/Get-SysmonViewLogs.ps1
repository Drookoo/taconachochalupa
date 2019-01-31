# .\Get-SysmonViewLogs.ps1 -HostsFile .\hosts.txt
# Log File Format - [HOST]:[DOMAIN]:[USERNAME]:[PASSWORD]
# By default, the program retrieves the Sysmon logs and saves them as a powershell object in xml format

param (
    [Parameter(Mandatory=$true)][string]$HostsFile,
    [Parameter(Mandatory=$false)][Switch]$SysmonView
)

# Read config file containing list of hosts and credentials
$HostFileData = Get-Content $HostsFile

# For each host in the file, retrieve Sysmon logs in SysmonView format
foreach ($line in $HostFileData) {
    # Split fields into values
    $line = $line -split (":")
    $Computer = $line[0]
    $Domain = $line[1]
    $Username = $line[2]
    $Password = $line[3]

    # Generate PsCredential object
    $SecureStringPassword = $Password | ConvertTo-SecureString -AsPlainText -Force
    $PSCredentialUsername = $Domain + "\" + $Username
    echo $PSCredentialUsername
    $Credential = New-Object System.Management.Automation.PSCredential($PSCredentialUsername, $SecureStringPassword)

    # this takes wayyy too long...need to quicken this up
    $LogFilename = $Computer + "_PowerShell_EventLogs.xml"
    Write-Host Pulling Sysmon logs from $Computer
    $Events = Get-WinEvent -LogName Microsoft-Windows-Sysmon/Operational -ComputerName $Computer -Credential $Credential -Oldest
    Write-Host Pulled $Events.count events
    $Events | Export-Clixml $LogFilename

    if($SysmonView) {
        $LogFilename = $Computer + "_SysmonView_EventLogs.xml"
        $WevtutilCmdString = "WEVTUtil query-events 'Microsoft-Windows-Sysmon/Operational' /r:" + $Computer + " /u:" + ($Domain+"\"+$Username) + " /p:" + $Password + " /format:xml /e:sysmonview > " + $LogFilename
        echo $WevtutilCmdString
        Invoke-Expression $WevtutilCmdString
    }
}
