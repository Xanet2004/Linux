Script to create users easier.

```powershell title="server1 - C:\Users\Administrator\scripts\ad\create-ad-users-from-template.ps1"
# SCRIPT START ----------------------------------------------------
Import-Module ActiveDirectory                        # AD cmdlets
Clear-Host

# list OUs and pick one
$ous = Get-ADOrganizationalUnit -Filter * | Select-Object Name, DistinguishedName
[int]$i = 0
"Available OUs:"
foreach ($ou in $ous) {
  $i++; "{0}. {1}" -f $i, $ou.Name
}
$choice = Read-Host "Select OU number"
if (-not ($choice -as [int]) -or $choice -lt 1 -or $choice -gt $ous.Count) {
  Write-Host "Invalid selection. Exiting." -ForegroundColor Red; return
}
$selectedOu = $ous[$choice - 1].DistinguishedName

# helper: get domain from DN (DC parts)
function Get-DomainFromDN($dn){
  $dcParts = ($dn -split ',') | Where-Object { $_ -like 'DC=*' } | ForEach-Object { ($_ -split '=')[1] }
  return ($dcParts -join '.')
}

$domain = Get-DomainFromDN $selectedOu

# loop to create users
do {
  $fullname = Read-Host "Full name (e.g. John Doe)"
  if ([string]::IsNullOrWhiteSpace($fullname)) { Write-Host "Empty name. Exiting."; break }

  # generate samAccountName from first + last initial (simple)
  $parts = $fullname.Split(' ', [System.StringSplitOptions]::RemoveEmptyEntries)
  if ($parts.Count -ge 2) { $sam = ($parts[0].Substring(0,1) + $parts[-1]).ToLower() } else { $sam = $fullname.ToLower().Replace(' ','') }

  $sam = Read-Host "SAM account name [$sam]" -Prompt "Press Enter to accept" | ForEach-Object { if ($_ -eq '') { $sam } else { $_ } }

  $upnDefault = "$($sam)@$domain"
  $upn = Read-Host "UserPrincipalName (email) [$upnDefault]" 
  if ([string]::IsNullOrWhiteSpace($upn)) { $upn = $upnDefault }

  # password (secure)
  $pwd = Read-Host "Password (will be stored as account password)" -AsSecureString

  # create user
  New-ADUser -Name $fullname `
    -SamAccountName $sam `
    -UserPrincipalName $upn `
    -AccountPassword $pwd `
    -Enabled $true `
    -Path $selectedOu

  # show short message
  Write-Host "`nUser '$fullname' (sAMAccountName: $sam, UPN: $upn) has been created." -ForegroundColor Green

  $again = Read-Host "Create another user in the same OU? (y/n)"
} while ($again -match '^[Yy]')
# SCRIPT END ------------------------------------------------------
```