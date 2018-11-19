#Must install Choco (type this out manually) through ps
#Run 'Get-ExecutionPolicy' 
#if "Restricted", then run 'Set-ExecutionPolicy' or 'Set-ExecutionPolicy Bypass -Scope Process'
#Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
#verify using 'choco'

#install git
#choco install -y git

#show installed updates 
Get-Hotfix

#Show number of updates available
$computername = $env:COMPUTERNAME
$updatesession =  [activator]::CreateInstance([type]::GetTypeFromProgID("Microsoft.Update.Session",$Computername))
$searchresult = $updatesearcher.Search("IsInstalled=0")  # 0 = NotInstalled | 1 = Installed
$searchresult.Updates.Count 

#Dont know if this will run code 
$IsDownloaded = $Updates|group IsDownloaded

#Index 1 is downloaded updates 
$IsDownloaded[1].Group  

$IsDownloaded[1].Group  | Export-Csv -NoTypeInformation  -Path DownloadedUpdates.csv



