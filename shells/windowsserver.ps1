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

#This might not work

If($Results.Count -eq 0) 
{ 
    Write-Warning "The SamAccountName '$UserName' cannot find. Please make sure that it exists." 
} 
Else 
{ 
    Foreach($Result in $Results) 
    { 
        $DistinguishedName = $Result.Properties.Item("DistinguishedName") 
        $LastLogonTimeStamp = $Result.Properties.Item("LastLogonTimeStamp") 
             
        If ($LastLogonTimeStamp.Count -eq 0) 
        { 
            $Time = [DateTime]0 
        } 
        Else 
        { 
            $Time = [DateTime]$LastLogonTimeStamp.Item(0) 
        } 
        If ($LastLogonTimeStamp -eq 0) 
        { 
            $LastLogon = $Time.AddYears(1600) 
        } 
        Else 
        { 
            $LastLogon = $Time.AddYears(1600).ToLocalTime() 
        }
$Hash = @{ 
                    SamAccountName = $UserName 
                    LastLogonTimeStamp = $(If($LastLogon -match "12/31/1600") 
                                            { 
                                                "Never Logon" 
                                            } 
                                            Else 
                                            { 
                                                $LastLogon 
                                            }) 
                    } 
        $Objs = New-Object -TypeName PSObject -Property $Hash 
  
        $Objs                         
    } 
}

