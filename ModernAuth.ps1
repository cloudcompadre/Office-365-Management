
DO {

write-host -ForegroundColor Yellow "----------------------------------------------"
write-host -ForegroundColor Yellow "1 = Check + Download Runtimes and Modules"
write-host -ForegroundColor Yellow "2 = Activate Modern Authentication"
write-host -ForegroundColor Yellow "----------------------------------------------"
$mode = read-host "Select an option from 1-3"



#Start Switch
switch($mode){

## Download Runtimes
1 {
write-host -foregroundcolor yellow "Checkin runtime.." 

$runtime = Get-ItemProperty "hklm:\software\microsoft\windows\currentversion\uninstall\*" | where {$_.DisplayName -like "*Microsoft Visual C++ 2017 x64 Minimum Runtime*"} | select DisplayName
if (!$runtime) {

write-host -foregroundcolor yellow "Runtime missing, installing runtime... - A succefull installation will require you to reboot the computer"

Invoke-WebRequest -Uri https://aka.ms/vs/15/release/vc_redist.x64.exe -OutFile "$env:userprofile\downloads\VSCruntime.exe"

set-location "$env:userprofile\downloads"

.\VSCruntime.exe

        }
elseif ($runtime) {
write-host -ForegroundColor yellow "Runtime already installed"
                }

    


## Download Skype Module

write-host -foregroundcolor yellow "Checkin Skype Online.." 

$skypeonline = Get-ItemProperty "hklm:\software\microsoft\windows\currentversion\uninstall\*" | where {$_.DisplayName -like "*Skype for Business Online*"} | select DisplayName
if (!$skypeonline) {

write-host -foregroundcolor yellow "Skype Online module missing, installing module..."

Invoke-WebRequest -Uri https://download.microsoft.com/download/2/0/5/2050B39B-4DA5-48E0-B768-583533B42C3B/SkypeOnlinePowerShell.Exe -OutFile "$env:userprofile\downloads\skypeonlinePS.exe"

set-location "$env:userprofile\downloads"

.\skypeonlinePS.exe

                    }
                    elseif ($runtime) {
                        write-host -ForegroundColor yellow "Skype Online module already installed"
                                        }
 
## Download Exchange Online Module

write-host -foregroundcolor yellow "Checkin Exchange Online.." 

$exchangeonline = ((Get-ChildItem -Path $($env:LOCALAPPDATA + '\Apps\2.0\') -Filter Microsoft.Exchange.Management.ExoPowershellModule.dll -Recurse).FullName | ?{ $_ -notmatch '_none_' } | Select-Object -First 1)
if (!$exchangeonline) {

write-host -foregroundcolor yellow "Exchange Online module missing, installing module..."

Invoke-WebRequest -Uri https://cmdletpswmodule.blob.core.windows.net/exopsmodule/Microsoft.Online.CSE.PSModule.Client.application -OutFile "$env:userprofile\downloads\exchangeonlinePS"

set-location "$env:userprofile\downloads"

.\exchangeonlinePS

                    }
                    elseif ($exchangeonline) {
                        write-host -ForegroundColor yellow "Exchange Online module already installed"
                                        }
          

## Download SharePoint Online Module

write-host -foregroundcolor yellow "Checkin SharePoint Online.." 

$sharepointonline = Get-ItemProperty "hklm:\software\microsoft\windows\currentversion\uninstall\*" | where {$_.DisplayName -like "*Sharepoint*"} | select DisplayName
if (!$sharepointonline) {

write-host -foregroundcolor yellow "SharePoint Online module missing, installing module..."

Invoke-WebRequest -Uri https://download.microsoft.com/download/0/2/E/02E7E5BA-2190-44A8-B407-BC73CA0D6B87/SharePointOnlineManagementShell_7618-1200_x64_en-us.msi -OutFile "$env:userprofile\downloads\sharepointonlinePS.msi"

set-location "$env:userprofile\downloads"

.\sharepointonlinePS.msi

}
elseif ($sharepointonline) {
    write-host -ForegroundColor yellow "SharePoint Online Module already installed"
                    }


$mode = 0
} ## End Switch 1 (Download Runtimes and Modules)

## Activate Modern Authentication
2 {
    Import-module SkypeOnlineConnector | wait-job
    Import-Module -Name $((Get-ChildItem -Path $($env:LOCALAPPDATA + '\Apps\2.0\') -Filter Microsoft.Exchange.Management.ExoPowershellModule.dll -Recurse).FullName | ?{ $_ -notmatch '_none_' } | Select-Object -First 1)
    Import-module Microsoft.Online.SharePoint.PowerShell | Wait-Job

    ##Skype
    $skypesession = new-csonlinesession
    Import-pssession $skypesession
    Write-Host -ForegroundColor yellow "Activating Modern Authentication for Skype Online"
    Set-CsOAuthConfiguration -ClientAdalAuthOverride Allowed
    

    ##Exchange Online
    $EXOSession = New-ExoPSSession
    Import-PSSession -Session $EXOSession -AllowClobber 
    Write-Host -ForegroundColor yellow "Activating Modern Authentication for Exchange Online"
    Set-OrganizationConfig -O2Auth2ClientProfileEnabled $true
   

    Get-PSSession | Remove-PSSession

    $mode = 0
}


default {write-host "Select an option!"}



}## End Switch

} While($mode -ne (1 -or 2))