### Antolaketa Unitateak

![[img01-OU.png]]

```powershell title:"Variables"
 # Network adapter
 
 $adapterName = "Ethernet"
 
 # IP and DNS
 
 $serverAddress = "192.168.1.100"
 $clientAddress = "192.168.1.50"
 $prefixLenght = 24
 $gateway = "192.168.1.2"
 $dnsAddresses = @("172.17.10.9", "8.8.8.8")
 
 # Hostname
 
 $hostname = "server"
 
 # Active Directory
 
 $domainName = "enpresa.eus"
 $domainNetName = "ENPRESA"
 $adminPassword = "Admin123*"
 
 # Organizative Units
 
 $parts = $domainName.Split(".")
 $domain1 = $parts[0]
 $domain2 = $parts[1]
 
 $OUName = @("Langileak", "Ikasleak", "Informatika", "Mekanika", "Medikuntza")
 $OUPassword = @("Langileak123*", "Ikasleak123*")
  
 ```
 
```powershell title="Organizative Units"
$OUId = 1 # 1 = Ikasleak

# OU bat sortu
New-ADOrganizationalUnit -Name $($OUName[$OUId]) -Path "OU=$($OUName[$OUId]),DC=$domain1,DC=$domain2" 

# Informatika, Mekanika, Medikuntza
New-ADOrganizationalUnit -Name $($OUName[2]) -Path "OU=$($OUName[$OUId]),DC=$domain1,DC=$domain2" 
New-ADOrganizationalUnit -Name $($OUName[3]) -Path "OU=$($OUName[$OUId]),DC=$domain1,DC=$domain2" 
New-ADOrganizationalUnit -Name $($OUName[4]) -Path "OU=$($OUName[$OUId]),DC=$domain1,DC=$domain2" 

# Medikuntza OU ezabatu
Set-ADOrganizationalUnit -Identity "OU=$($OUName[4]),OU=$($OUName[$OUId]),DC=$domain1,DC=$domain2" -ProtectedFromAccidentalDeletion $false 
Remove-ADOrganizationalUnit -Identity "OU=$($OUName[4]),OU=$($OUName[$OUId]),DC=$domain1,DC=$domain2" 

# OU guztiak bistaratu
Get-ADOrganizationalUnit -Filter * 
```

### Domeinu-erabiltzaileak

```powershell title="Erabiltzaileak sortu"
$OUId = 2 # 3 = Informatika

$DUName = "Xanet Zaldua"
$DUParts = $DUName.Split(" ")
$DUGivenName = $DUParts[0]
$DUSurname = $DUParts[1]
$DUGivenNameLow = $DUGivenName.ToLower()
$DUSurnameLow = $DUSurname.ToLower()
$DUAccountName = "$($DUGivenNameLow[0])$DUSurnameLow"

New-ADUser `
   -Name $DUName `
   -DisplayName $DUName `
   -GivenName $DUGivenName `
   -Surname $DUSurname `
   -SamAccountName $DUAccountName `
   -UserPrincipalName "$DUAccountName@$domainName" `
   -Path "OU=$($OUName[$OUId]),OU=$($OUName[1]),DC=$domain1,DC=$domain2" `
   -AccountPassword (ConvertTo-SecureString $OUPassword[1] -AsPlainText -Force) `
   -Enabled $true
```

![[img02-user.png]]
![[img03-user.png]]

#### Erakutxi erabiltzaileak

![[img04-user.png]]
![[img05-user.png]]
![[img06-user.png]]
### Domeinu-taldeak

```powershell title="Taldea sortu"
$groupName = "Bigarren"
$OUId = 2 # 3 = Informatika

New-ADGroup `
  -Name $groupName `
  -SamAccountName $groupName `
  -DisplayName $groupName `
  -GroupScope Global `
  -GroupCategory Security `
  -Path "OU=$($OUName[$OUId]),OU=$($OUName[1]),DC=$domain1,DC=$domain2"
```

```powershell title="Konprobatu"
Get-ADGroup -Identity $groupName
```

![[img07-GroupCreated.png]]

```powershell title="Erabiltzailea taldean"
$userAccount = "xzaldua"
$groupName = "Bigarren"

Add-ADGroupMember -Identity $groupName -Members $userAccount
```

```powershell title="Erabiltzailea konprobatu"
Get-ADGroupMember -Identity $groupName | Select-Object Name, SamAccountName
```
![[img08-UserInGroup.png]]