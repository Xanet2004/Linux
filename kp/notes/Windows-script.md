

```powershell title="execution"
.\imports.ps1
```

```powershell title="basic euskaraz"
# AD Module inportatu
Import-Module ActiveDirectory

# TODO: CSV fitxategiaren path-a eta erabiltzaileak sortuko diren OU-a definitu.
$csvPath = "C:\Users\Administrator\Documents\langileak.csv"
$targetOU = "OU=Users,DC=GARAIA,DC=corp"

# CSV fitxategia irakurri
$users = Import-Csv -Path $csvPath

foreach ($user in $users) {
   # Convert plain text password to Secure String
   $securePassword = ConvertTo-SecureString $user.Password -AsPlainText -Force

   # TODO: Erabiltzailea sortu
   New-ADUser -Name $user.Name -GivenName $user.GivenName -Surname $user.Surname -SamAccountName $user.SamAccountName -UserPrincipalName $user.UserPrincipalName -Path $targetOU -AccountPassword $securePassword -Enabled $true -ChangePasswordAtLogon $false
}
```

```powershell title="basic"
# Import AD Module
Import-Module ActiveDirectory

# TODO: Define CSV file path and the OU where users are going to be created
$csvPath = "C:\Users\Administrator\Documents\langileak.csv"
$targetOU = "CN=Users,DC=GARAIA,DC=corp"

# read CSV file
$users = Import-Csv -Path $csvPath

foreach ($user in $users) {
   # Convert plain text password to secure String
   $securePassword = ConvertTo-SecureString $user.Password -AsPlainText -Force

   # TODO: create user
   New-ADUser -Name $user.Name -GivenName $user.GivenName -Surname $user.Surname -SamAccountName $user.SamAccountName -UserPrincipalName $user.UserPrincipalName -Path $targetOU -AccountPassword $securePassword -Enabled $true -ChangePasswordAtLogon $false
}
```

```powershell title="tryhard"
# Import AD Module
Import-Module ActiveDirectory

# TODO: Define CSV file path and the OU where users are going to be created
$csvPath = "C:\Users\Administrator\Documents\langileak.csv"
$targetOU = "CN=Users,DC=GARAIA,DC=corp"

# read CSV file
$users = Import-Csv -Path $csvPath

foreach ($user in $users) {
   # Convert plain text password to secure String
   $securePassword = ConvertTo-SecureString $user.Password -AsPlainText -Force

   # TODO: create user
   $existing = Get-ADUser -Filter { SamAccountName -eq $user.SamAccountName } -ErrorAction SilentlyContinue
   if ($null -ne $existing) {
       Write-Host "Skipping existing user: $($user.SamAccountName)"
       continue
   }

   try {
       New-ADUser `
           -Name $user.Name `
           -GivenName $user.GivenName `
           -Surname $user.Surname `
           -SamAccountName $user.SamAccountName `
           -UserPrincipalName $user.UserPrincipalName `
           -Path $targetOU `
           -AccountPassword $securePassword `
           -Enabled $true `
           -ChangePasswordAtLogon $false
       Write-Host "Created user: $($user.SamAccountName)"
   } catch {
       Write-Host "Error creating $($user.SamAccountName): $_"
   }
}
```