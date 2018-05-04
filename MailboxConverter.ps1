## Auth O365 Tenant Admin
write-host "Logga in med administratörsrättigheter i aktuell O365-tenant."
$UserCredential = Get-Credential

## Store PS-Session info for Exchange Online-connection.
$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection

## Run the Exchange Online PS-Session stored.
Import-PSSession $Session


## DataMumboJumbo
 
Write-Host " ------------------------------------------------------------------------------------------------"
Write-Host " ------------------------------------------------------------------------------------------------"
Write-Host "Konvertering av mailbox till delad samt borttagning av samtliga licenser för användaren i Office 365"
Write-Host " ------------------------------------------------------------------------------------------------"
Write-Host " ------------------------------------------------------------------------------------------------"



## Define variables for users.
$UserName = Read-Host "Fyll i förnamn samt efternamn enligt konventionen(John Doe) på användarens mailbox som skall konverteras."
Write-Host " ------------------------------------------------------------------------------------------------"
$UPN = Read-Host "Fyll i UPN enligt konventionen(John.Doe@Ants.se) för användarens AAD/O365-konto."
Write-Host " ------------------------------------------------------------------------------------------------"

## Convert regular mailbox to shared.
set-mailbox $UserName -Type shared
Write-Host "Mailbox konverterad.."


## Connect to Microsoft Online (O365) with the same credentials stored.
connect-msolservice -credential $UserCredential
(get-MsolUser -UserPrincipalName $upn).licenses.AccountSkuId |
foreach{
    Set-MsolUserLicense -UserPrincipalName $upn -RemoveLicenses $_
}

## DataMumboJumbo
Write-Host "Licenser bortplockade.."
Write-Host "Laddar information..."


Start-sleep -Seconds 10

## DataMumboJumbo
Write-Host "Nedanstående mailboxar är delade"


## List shared mailboxes in the tenant.
get-mailbox -filter '(RecipientTypeDetails -eq "SharedMailbox")' | select-object DisplayName,Alias,RecipientTypeDetails

# DataMumboJumbo och tryck för att avsluta.
Write-Host "Tryck för att avsluta och koppla från aktiva sessioner"
Pause

Remove-PSSession $Session