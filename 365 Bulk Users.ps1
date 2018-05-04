## Licensnamn "STANDARDWOFFPACK_STUDENT" (Unlimited)

Import-Module MSOnline

#Anslut till 365
connect-msolservice

#Importera användarlista
$userlist = Import-Csv C:\Users\DRE\Desktop\testlista.csv

#Skapa användare enligt listan (Förnamn, Efternamn, UPN, Lösenord, Licens)
$userlist | ForEach-Object {

New-MsolUser -UserPrincipalName $_.UserPrincipalName -FirstName $_.FirstName -LastName $_.LastName -DisplayName "Test Testsson" -UsageLocation "SE" -Password !GoPro1337 -LicenseAssignment "brommaenskilda:STANDARDWOFFPACK_STUDENT"

 }