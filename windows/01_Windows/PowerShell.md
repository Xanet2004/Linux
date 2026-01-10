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
 $adminName = "Administrator"
 $adminPassword = "Admin123*"
 
 # Organizative Units
 
 $parts = $domainName.Split(".")
 $domain1 = $parts[0]
 $domain2 = $parts[1]
 
 $OUName = @("Langileak", "example")
 $OUPassword = @("Langileak123*", "example123*")
 ```

```powershell title:"Code"
# Network adapter

Get-NetAdapter

Get-Net-IpConfiguration -InterfaceAlias $adapterName

# Enable and disable netowork adapter
## Enable-NetAdapter -Name $adapterName
## Disable-NetAdapter -Name $adapterName -Confirm:$false

# Rename network adapter
## Rename-NetAdapter -Name $adapterName -NewName "NewName"


# IP eta DNS estatikoak

New-NetIPAddress -InterfaceAlias $adapterName -IPAddress $serverAdress -PrefixLength $prefixLenght -DefaultGateway $gateway

Set-DnsClientServerAddress -InterfaceAlias $adapterName -ServerAddresses ($dnsAddresses[0],$dnsAddresses[1])

# IP eta DNS automatikoak (DHCP)
New-NetIPAddress -InterfaceAlias $adapterName -Dhcp Enabled

Set-DnsClientServerAddress -InterfaceAlias $adapterName -ResetServerAddresses

# Remove static IP adress
## Get-NetIPAddress -InterfaceAlias $adapterName | Remove-NetIPAddress

# Gateway-a mantentzen bada, ruta estatikoa ezabatu behar da
## Remove-NetRoute -NextHop "192.168.1.1" -InterfaceIndex "15"


# Hostname

hostname

Rename-Computer -NewName $hostname -Restart
```

```powershell title="Active Directory"
# Active Directory instalazioa

Add-WindowsFeature -Name "ad-domain-services" -IncludeAllSubFeature -IncludeManagementTools

Add-WindowsFeature -Name "dns" -IncludeAllSubFeature -IncludeManagementTools

Add-WindowsFeature -Name "gpmc" -IncludeAllSubFeature -IncludeManagementTools


# Active Directory baso bat sortu

Install-ADDSForest `
	-CreateDnsDelegation:$false ` 
	-DatabasePath "c:\windows\NTDS" ` 
	-DomainMode "WinThreshold" ` 
	-DomainName $domainName ` 
	-SafeModeAdministratorPassword (ConvertTo-SecureString $adminPassword -AsPlainText -Force) ` 
	-DomainNetbiosName $domainNetName ` 
	-ForestMode "WinThreshold" ` 
	-InstallDns:$true ` 
	-LogPath "c:\windows\NTDS" ` 
	-NoRebootOnCompletion:$false ` 
	-SysvolPath "c:\windows\SYSVOL" ` 
	-Force:$true







Install-ADDSForest `
	-CreateDnsDelegation:$false ` 
	-DatabasePath "c:\windows\NTDS" ` 
	-DomainMode "WinThreshold" ` 
	-DomainName "garaia.lab" ` 
	-SafeModeAdministratorPassword (ConvertTo-SecureString "Kpw123" -AsPlainText -Force) ` 
	-DomainNetbiosName "GARAIA" ` 
	-ForestMode "WinThreshold" ` 
	-InstallDns:$true ` 
	-LogPath "c:\windows\NTDS" ` 
	-NoRebootOnCompletion:$false ` 
	-SysvolPath "c:\windows\SYSVOL" ` 
	-Force:$true
	
	
	
	
	
	
	
	
	
	
```

```powershell title="Active Directory EGIAZTAPENA"
# Active Directory egiaztapena

Get-Service -Name NTDS

# Egiaztatu domeinu-kontrolatzailea eskuragarri dagoela:

Test-Connection -ComputerName (Get-ADDomainController).Hostname

# Egiaztatu sare txartelean konfiguratutako DNS zerbitzaria 127.0.0.1 dela

Get-NetIPConfiguration -InterfaceAlias $adapterName 

# Egiaztatu DNS zerbitzaria exekutatzen ari dela

Get-Service -Name DNS

# Probatu DNS kontsulten ebazpena

Resolve-DnsName -Name $domainName -Server (Get-ADDomainController).Hostname
```

```powershell title="Organizative Units"
$OUId = 0

# OU bat sortu
New-ADOrganizationalUnit -Name $($OUName[$OUId]) -Path "DC=$domain1,DC=$domain2" 

# OU bat ezabatu
#Set-ADOrganizationalUnit -Identity "OU=$($OUName[$OUId]),DC=$domain1,DC=$domain2" -ProtectedFromAccidentalDeletion $false 
# Remove-ADOrganizationalUnit -Identity "OU=$($OUName[$OUId]),DC=$domain1,DC=$domain2" 

# OU guztiak bistaratu
Get-ADOrganizationalUnit -Filter * 

# OU konkretu bat bistaratu
Get-ADOrganizationalUnit -Identity "OU=$($OUName[$OUId]),DC=$domain1,DC=$domain2"
```

```powershell title="Domain Users"

$OUId = 0

$DUName = "Xabier Etxezarreta"
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
   -Path "OU=$($OUName[$OUId]),DC=$domain1,DC=$domain2" `
   -AccountPassword (ConvertTo-SecureString $OUPassword[$OUId] -AsPlainText -Force) `
   -Enabled $true
```

```powershell title="Organizative Unit Groups"
$OUId = 0

$DUName = "Xabier Etxezarreta"
$DUParts = $DUName.Split(" ")
$DUGivenName = $DUParts[0]
$DUSurname = $DUParts[1]
$DUGivenNameLow = $DUGivenName.ToLower()
$DUSurnameLow = $DUSurname.ToLower()
$DUAccountName = "$($DUGivenNameLow[0])$DUSurnameLow"

$ADGroup = "Azpiegiturak"

# Talde berri bat sortu
New-ADGroup -Name $ADGroup -GroupScope Global -GroupCategory Security -Path "OU=$($OUName[$OUId]),DC=$domain1,DC=$domain2"

# Talde bat ezabatu
#Remove-ADGroup -Identity $ADGroup

# OU bateko taldeak bistaratu
Get-ADGroup -SearchBase "OU=$($OUName[$OUId]),DC=$domain1,DC=$domain2" -Filter *

# Erabiltzaile bat talde baten sartu
Add-ADGroupMember -Identity $ADGroup -Members $DUAccountName

# Talde bateko erabiltzaileak bistaratu
Get-ADGroupMember -Identity $ADGroup

# Erabiltzaile bat talde batetik ezabatu
#Remove-ADGroupMember -Identity $ADGroup -Members $DUAccountName -Confirm:$false
```

```powershell title="Client Configuration"
# DNS
Set-DnsClientServerAddress -InterfaceAlias $adapterName -ServerAddresses $serverAddress

# Ordenagailua domeinura sartu
Add-Computer -DomainName $domainName -Credential $adminName

# Domeinutik kendu
## Remove-Computer -UnjoinDomaincredential $adminName -WorkgroupName "WORKGROUP" -Restart
```

```powershell title="Shared Folders"
# Partekatutako karpeten informazioa bistaratu. 
Get-SmbShare

# Karpeta bat sarean partekatu. Defektuz, ezer ez bada definitzen irakurtzeko baimenak ezartzen dira. 
# Hainbat erabiltzaile edo talde zerrenda ditzakezu komaz bereizita.
#    FullAccess: Grants complete control (read, write, modify, delete).
#    ChangeAccess: Allows modifying files and subfolders. 
#    ReadAccess: Allows viewing files and subfolders. 
#    NoAccess: Prevents any access.

$sharedFolder = "Shared"
$sharedFolderPath = "C:\Shared"
$access = "Everyone"

New-SmbShare -Name $sharedFolder -Path $sharedFolderPath -FullAccess $access 

# Partekatutako karpeta ezabatu.
##Remove-SmbShare -Name $sharedFolder

# Karpeta bat sortu
mkdir C:\Shared\Dokumentuak

# Konprobatu esa karpeta partekatu den
Get-SmbShare
Get-SmbShareAccess -Name "Dokumentuak"
```

```powershell title="Share baimenak"
# Ordeztu "ShareName" partekatze-izenarekin (adibidez, 'Aplikazioak' edo 'Dokumantuak').
Get-SmbShareAccess -Name $sharedFolder

# Ordeztu "C:\SharedFolder\Path" partekatutako karpetaren tokiko patharekin. 
(Get-Acl -Path "C:\SharedFolder\Path").Access | Format-Table -AutoSize


# Baimenak gehitu eta kendu
Grant-SmbShareAccess -Name $sharedFolder -AccountName "Domain\UserOrGroup" -AccessRight Full
Block-SmbShareAccess -Name $sharedFolder -AccountName "Domain\UserOrGroup" -Force

# NTFS baimenak gehitu eta kendu
$Path = "C:\SharedFolder\Path"
$User = "Domain\UserOrGroup" $Permission = "Read, Write" # Can be: Read, Write, Modify, FullControl, Delete, ExecuteFile, ListDirectory 
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
```

```powershell title="DNS"
# Instalatu
Install-WindowsFeature -Name DNS -IncludeManagementTools

# Get records in a zone
Get-DnsServerResourceRecord -ZoneName $domainName

# Create a new A record
Add-DnsServerResourceRecordA -Name "www" -ZoneName $domainName -IPv4Address "192.168.1.200" 

# Delete a record
#Remove-DnsServerResourceRecord -ZoneName $domainName -Name "www" -RRType "A" -Force
```

```powershell title="Forward zoneak"
# List forward zones 
Get-DnsServerZone 

# Create a New DNS Forward Zone 
Add-DnsServerPrimaryZone -Name "enpresatest.eus" -ReplicationScope "Domain" -PassThru 

#Delete a DNS Forward Zone 
#Remove-DnsServerZone -Name "enpresatest.eus" -Force
```

```powershell title="Reverse Zone"
# List reverse lookup zones 
Get-DnsServerZone 

# Create a New DNS Reverse Zone 
Add-DnsServerPrimaryZone -NetworkID 192.168.1/24 -ReplicationScope Domain 

#Delete a DNS Reverse Zone 
#Remove-DnsServerZone -Name "1.168.192.in-addr.arpa"
```

```powershell title="Reverse Zone sarrerak"
# Get Records in a Reverse Lookup Zone
Get-DnsServerResourceRecord -ZoneName "1.168.192.in-addr.arpa" 

# Create a PTR Record (Reverse Lookup Entry) 
Add-DnsServerResourceRecordPtr -Name "100" -ZoneName "1.168.192.in-addr.arpa" -PtrDomainName $domainName

# Delete a PTR Record
#Remove-DnsServerResourceRecord -ZoneName "1.168.192.in-addr.arpa" -Name "100" -RRType PTR -Force
```

```powershell title="DHCP"
# Install the DHCP Server role 
Install-WindowsFeature -Name DHCP -IncludeManagementTools 

# Verify that the DHCP role is installed 
Get-WindowsFeature -Name DHCP
```

```powershell title="DHCP konfigurazioa"
# List DHCP scopes 
Get-DhcpServerv4Scope 

# Add a new DHCP scope 
Add-DhcpServerv4Scope -Name "Scope Enpresa" -StartRange "192.168.1.2" -EndRange "192.168.1.254" -SubnetMask "255.255.255.0" -State Active -Description "Primary IPv4 Scope" 

# Delete DHCP scope 
#Remove-DhcpServerv4Scope -ScopeId "192.168.1.0" -Force 

# Add IP exclusion range 
Add-DhcpServerv4ExclusionRange -ScopeId "192.168.1.0" -StartRange "192.168.1.100" -EndRange "192.168.1.105" 

# Set the default gateway for the scope 
Set-DhcpServerv4OptionValue -ScopeId "192.168.1.0" -Router "192.168.1.1" 

# Set DNS server for the scope 
Set-DhcpServerv4OptionValue -ScopeId "192.168.1.0" -DnsServer "192.168.1.100" 

# Set the lease duration for the scope 
Set-DhcpServerv4Scope -ScopeId "192.168.1.0" -LeaseDuration "8.00:00:00" 

# 8 days # Authorize the DHCP server in Active Directory 
Add-DhcpServerInDC -DnsName "Server" -IpAddress "192.168.1.100" 
```

```powershell title="DHCP reservation"
$maxAddress = "08-00-27-21-C9-C3"
$reservedIp = "192.168.1.50"
$red = "192.168.1.0"
Add-DhcpServerv4Reservation -ScopeId $red -IPAddress $reservedIp -ClientId $maxAddress -Description "Reserva para cliente específico"
```

```powershell title="www"
# Install the Web Server Role
Install-WindowsFeature -name Web-Server -IncludeManagementTools 

# Verify the Installation
Get-WindowsFeature Web-Server

# List websites 
Get-Website 

$websiteName = "hello_world"
$websitePath = "C:\Sites\HelloWorld"
$websiteHost = "*:80:www.enpresa.eus"

# Create a website 
New-IISSite -Name $websiteName -PhysicalPath $websitePath -BindingInformation $websiteHost

# Deleting a Website 
##Remove-Website -Name "hello_world" 
```

```powershell title="Remote Desktop Protocol"
# RDP bidezko urruneko sarbidea aktibatu 
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name "fDenyTSConnections" -Value 0 
Enable-NetFirewallRule -DisplayGroup "Remote Desktop" 

# RDP bidezko urruneko sarbidea desaktibatu 
Set-ItemProperty -Path 'HKLM:\System\CurrentControlSet\Control\Terminal Server' -Name "fDenyTSConnections" -Value 1 
Disable-NetFirewallRule -DisplayGroup "Remote Desktop"
```

```powershell

mkdir C:\Scripts
New-Item -ItemType File -Name "c:\Scripts\sortu.ps1" 


#################3

$parts = $domainName.Split(".")
$domain1 = $parts[0]
$domain2 = $parts[1]

$OUName = @("Zuzendariak", "Laborategia", "Irakasleak", "Erabiltzaileak")
$OUPassword = @("Zuzendariak123*", "Laborategia123*", "Irakasleak123*", "Erabiltzaileak123*")

$OUId = 0

$DUName = "Xabier Etxezarreta"

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
   -Path "OU=$($OUName[$OUId]),DC=$domain1,DC=$domain2" `
   -AccountPassword (ConvertTo-SecureString $OUPassword[$OUId] -AsPlainText -Force) `
   -Enabled $true

#####################

$OUId = 1
$OUId2 = 2

$DUName = "Iñaki Garitano"

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
   -Path "OU=$($OUName[$OUId2]),OU=$($OUName[$OUId]),DC=$domain1,DC=$domain2" `
   -AccountPassword (ConvertTo-SecureString $OUPassword[$OUId2] -AsPlainText -Force) `
   -Enabled $true
   
#####################

$OUId = 1
$OUId2 = 3

$DUName = "Iñaki Garitano"

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
   -Path "OU=$($OUName[$OUId2]),OU=$($OUName[$OUId]),DC=$domain1,DC=$domain2" `
   -AccountPassword (ConvertTo-SecureString $OUPassword[$OUId2] -AsPlainText -Force) `
   -Enabled $true



```