#Must install Choco (type this out manually) through ps
#Run 'Get-ExecutionPolicy' 
#if "Restricted", then run 'Set-ExecutionPolicy' or 'Set-ExecutionPolicy Bypass -Scope Process'
#Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
#verify using 'choco'

#install git
#choco install -y git
#$env:Path += ";C:\Program Files\git\cmd"

#Get Installed Updates 
$Session = New-Object -ComObject "Microsoft.Update.Session"

$Searcher = $Session.CreateUpdateSearcher()
$historyCount = $Searcher.GetTotalHistoryCount()
$Searcher.QueryHistory(0, $historyCount) | Select-Object Date,@{name="Operation"; expression={switch($_.operation){1 {"Installation"}; 2 {"Uninstallation"}; 3 {"Other"}}}}, @{name="Status"; expression={switch($_.resultcode){1 {"In Progress"}; 2 {"Succeeded"}; 3 {"Succeeded With Errors"};4 {"Failed"}; 5 {"Aborted"} }}}, Title, Description | Export-Csv -NoType "$Env:userprofile\Desktop\Windows Updates.csv"


