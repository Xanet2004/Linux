Active directory commands

# Installation

```powershell title="installation"
Add-WindowsFeature -Name "ad-domain-services" -IncludeAllSubFeature -IncludeManagementTools
Add-WindowsFeature -Name "dns" -IncludeAllSubFeature -IncludeManagementTools
Add-WindowsFeature -Name "gpmc" -IncludeAllSubFeature -IncludeManagementTools
```

## AD Forest

```powershell title="ad forest"
Install-ADDSForest `
 -CreateDnsDelegation:$false `
 -DatabasePath "c:\windows\NTDS" `
 -DomainMode "WinThreshold" `
 -DomainName "enpresa.eus" `
 -SafeModeAdministratorPassword (ConvertTo-SecureString "Admin123*" `
 -AsPlainText -Force) ` -DomainNetbiosName "ENPRESA" `
 -ForestMode "WinThreshold" `
 -InstallDns:$true `
 -LogPath "c:\windows\NTDS" `
 -NoRebootOnCompletion:$false `
 -SysvolPath "c:\windows\SYSVOL" `
 -Force:$true
```

## Tree

In a previously created forest

```powershell title="installation"
$credential = Get-Credential
Install-ADDSDomain `
 -DomainType Tree `
 -NewDomainName "newcorp.com" `
 -ParentDomainName "enpresa.eus" `
 -Credential $credential `
 -InstallDns:$true `
 -DomainMode "WinThreshold" `
 -SafeModeAdministratorPassword (ConvertTo-SecureString "Admin123*" -AsPlainText -Force)
```

## Child domain

```powershell title="installation"
$credential = Get-Credential
Install-ADDSDomain `
 -DomainType Child `
 -NewDomainName "sales" `
 -ParentDomainName "enpresa.eus" `
 -Credential $credential `
 -InstallDns:$true `
 -DomainMode "WinThreshold" `
 -SafeModeAdministratorPassword (ConvertTo-SecureString "Admin123*" -AsPlainText -Force)
```

## Check service is running

```powershell title="service"
Get-Service -Name NTDS
```

## Check domain controller availabilty

```powershell title="domain controller"
Test-Connection -ComputerName (Get-ADDomainController).Hostname
```

## Check network interface DNS adapter

```powershell title="configured dns"
Get-NetAdapter
Get-NetIPConfiguration -InterfaceAlias "Ethernet"
```

## Check DNS service

```powershell title="dns"
Get-Service -Name DNS
```

## Check DNS resolves

```powershell title="dns resolves"
Resolve-DnsName -Name enpresa.eus -Server (Get-ADDomainController).Hostname
```

# OUs Users Groups

## Add user

```powershell title="add user"
New-ADUser `
 -Name "Iñaki Garitano" `
 -DisplayName "Iñaki Garitano" `
 -GivenName "Iñaki" `
 -Surname "Garitano" `
 -SamAccountName "igaritano" `
 -UserPrincipalName "igaritano@enpresa.eus" `
 -Path "OU=Langileak,DC=enpresa,DC=eus" `
 -AccountPassword (ConvertTo-SecureString "Langileak123*" -AsPlainText -Force) ` -Enabled $true
```

## Other user commands

```powershell title="other user commands"
# Erabiltzaile bat ezabatu
Remove-ADUser -Identity "igaritano" -Confirm:$false 

# Erabiltzailea aktibatu edo desaktibatu
Enable-ADAccount -Identity "igaritano" Disable-ADAccount -Identity "igaritano"

# OU bateko erabiltzaileak bistaratu
Get-ADUser -Filter * -SearchBase "OU=Langileak,DC=enpresa,DC=eus"

# Erabiltzaile baten informazioa bistaratu
Get-ADUser -Identity "igaritano" -Properties *

# Erabiltzaile baten datuak aldatu edo eguneratu
Set-ADUser -Identity "jdoe" -OfficePhone "555-1234"

# Erabiltzaile baten pasahitza aldatu
Set-ADAccountPassword -Identity "jdoe" -NewPassword (ConvertTo-SecureString "NewP@ssw0rd" -AsPlainText -Force) -Reset
```

## Groups

```powershell title="groups"
# Talde berri bat sortu
New-ADGroup -Name "Azpiegiturak" -GroupScope Global -GroupCategory Security -Path "OU=Langileak,DC=enpresa,DC=eus"

# Talde bat ezabatu
Remove-ADGroup -Identity "Azpiegiturak"

# OU bateko taldeak bistaratu
Get-ADGroup -SearchBase "OU=Langileak,DC=enpresa,DC=eus" -Filter *

# Talde bateko erabiltzaileak bistaratu
Get-ADGroupMember -Identity "Azpiegiturak"

# Erabiltzaile bat talde baten sartu
Add-ADGroupMember -Identity "Azpiegiturak" -Members "xetxezarreta"

# Erabiltzaile bat talde batetik ezabatu
Remove-ADGroupMember -Identity "Azpiegiturak" -Members "xetxezarreta" -Confirm:$false
```

# Devices
## Add computer to domain

```powershell title="add computer"
Add-Computer -DomainName "enpresa.eus" -Credential "Administrator"

# With credential
$Pass   = ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force
$Cred   = New-Object System.Management.Automation.PSCredential ($User, $Pass)

Add-Computer -DomainName "enpresa.eus" -Credential $Cred
```

## Remove computer from domain

```powershell title="remove computer"
Remove-Computer -UnjoinDomaincredential "Administrator" -WorkgroupName "WORKGROUP" -Restart

# With credential
$Pass   = ConvertTo-SecureString "P@ssw0rd" -AsPlainText -Force
$Cred   = New-Object System.Management.Automation.PSCredential ($User, $Pass)

Remove-Computer -UnjoinDomaincredential $Cred -WorkgroupName "WORKGROUP" -Restart
```

# Sharing

## Commands

```powershell title="add"
# Partekatutako karpeten informazioa bistaratu.
Get-SmbShare 

# Karpeta bat sarean partekatu. Defektuz, ezer ez bada definitzen irakurtzeko baimenak ezartzen dira. 
# Hainbat erabiltzaile edo talde zerrenda ditzakezu komaz bereizita. 
# FullAccess: Grants complete control (read, write, modify, delete). 
# ChangeAccess: Allows modifying files and subfolders.
# ReadAccess: Allows viewing files and subfolders. 
# NoAccess: Prevents any access. 
New-SmbShare -Name "ShareName" -Path "C:\path\to\folder" -FullAccess "UsersOrGroups" 

# Partekatutako karpeta ezabatu.
Remove-SmbShare -Name "ShareName"
```

## Create folder and files

```powershell title="mkdir"
mkdir C:\Shared\Dokumentuak

New-Item -ItemType File -Name "kaixo.txt"

Get-Content kaixo.txt

Set-Content kaixo.txt -Value "new content"
```

## Share folder

```powershell title="add"
New-SmbShare -Name "Dokumentuak" -Path "C:\Shared\Dokumentuak\" -ReadAccess "Everyone"
```

## Show share permissions

```powershell title="add"
# Ordeztu "ShareName" partekatze-izenarekin (adibidez, 'Aplikazioak' edo 'Dokumantuak').
Get-SmbShareAccess -Name "ShareName"
```

## Show NTFS permissions (file system)

```powershell title="add"
# Ordeztu "C:\SharedFolder\Path" partekatutako karpetaren tokiko patharekin.
(Get-Acl -Path "C:\SharedFolder\Path").Access | Format-Table -AutoSize
```

## Add and remove share permissions

```powershell title="add"
# AccessRights: Full, Change, Read
Grant-SmbShareAccess -Name "ShareName" -AccountName "Domain\UserOrGroup" -AccessRight Full
Block-SmbShareAccess -Name "ShareName" -AccountName "Domain\UserOrGroup" -Force
```

## Add and remove NTFS permissions

```powershell title="add"
$Path = "C:\SharedFolder\Path" 
$User = "Domain\UserOrGroup" 
$Permission = "Read, Write" # Can be: Read, Write, Modify, FullControl, Delete, ExecuteFile, ListDirectory 
$Inheritance = "ContainerInherit, ObjectInherit" # Fitxategi bat bada, None erabili 
$Type = "Allow" # Use "Deny" to explicitly block access 

# 1. Get the existing ACL 
$Acl = Get-Acl -Path $Path 

# 2. Create the new Access Rule 
$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule( $User, $Permission, $Inheritance, "None", $Type ) 

# 3. Add the new rule to the ACL 
$Acl.AddAccessRule($AccessRule) 

# 4. Apply the modified ACL 
Set-Acl -Path $Path -AclObject $Acl




$Path = "C:\Users\Administrator\Shared\BLAHAJ\federiko" 
$User = "imaritxalar" 
$Permission = "Read" # Can be: Read, Write, Modify, FullControl, Delete, ExecuteFile, ListDirectory 
$Inheritance = "None" # Fitxategi bat bada, None erabili 
$Type = "Allow" # Use "Deny" to explicitly block access 

# 1. Get the existing ACL 
$Acl = Get-Acl -Path $Path 

# 2. Create the new Access Rule 
$AccessRule = New-Object System.Security.AccessControl.FileSystemAccessRule( $User, $Permission, $Inheritance, "None", $Type ) 

# 3. Add the new rule to the ACL 
$Acl.AddAccessRule($AccessRule) 

# 4. Apply the modified ACL 
Set-Acl -Path $Path -AclObject $Acl
```

## Remove or delete share permissions

```powershell title="add"
# The -Force parameter bypasses the confirmation prompt. 
# Replace "Domain\UserOrGroup" with the actual user or group name 
Revoke-SmbShareAccess -Name "ShareName" -AccountName "Domain\UserOrGroup" -Force
```

## Remove or delete NTFS permissions

```powershell title="add"
$Path = "C:\SharedFolder\Path" 
$User = "Domain\UserOrGroup" 
$Acl = Get-Acl -Path $Path 

# Use PurgeAccessRules to remove all Allow/Deny entries for the user 
$Usersid = New-Object System.Security.Principal.NTAccount($User) 
$Acl.PurgeAccessRules($Usersid) 

# Apply the modified ACL 
Set-Acl -Path $Path -AclObject $Acl
```

## GPOs

[GPO configurations](/windows/services/configurationCommands/gpo.pdf)
