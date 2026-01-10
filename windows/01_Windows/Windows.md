---
AdapterName: Ethernet
ServerAddress: 192.168.1.100
ClientAddress: 192.168.1.50
Gateway: 192.168.1.2
DNSAddresses:
  - 172.17.10.9
  - 8.8.8.8
Hostname: server
DomainName: enpresa.eus
DomainNetName: ENPRESA
AdminPassword: Admin123*
---
# Sare konfigurazioa

## Bistaratu sare txarteleko konfigurazioak

```powershell title:"Get-NetAdapter"
Get-NetAdapter
# Adapter name: Ethernet
```

> [!NOTE] PowerShell
> Get-NetIPConfiguration -InterfaceAlias "<span query="get(AdapterName)"></span><span class="lv-live-text">Ethernet</span><span type="end"></span>"

```powershell title:"Komando Interesgarriak"
# Enable and disable netowrk adapter
Enable-NetAdapter -Name "YourAdapterName"
Disable-NetAdapter -Name "YourAdapterName" -Confirm:$false

# Rename network adapter
Rename-NetAdapter -Name "OldName" -NewName "NewName"
```

## IP eta DNS **estatikoak**

> [!PowerShell] PowerShell
> New-NetIPAddress -InterfaceAlias "<span query="get(AdapterName)"></span><span class="lv-live-text">Ethernet</span><span type="end"></span>" -IPAddress <span query="get(ServerAddress)"></span><span class="lv-live-text">192.168.1.100</span><span type="end"></span> -PrefixLength 24 -DefaultGateway <span query="get(Gateway)"></span><span class="lv-live-text">192.168.1.2</span><span type="end"></span>
> 
> 
> Set-DnsClientServerAddress -InterfaceAlias "<span query="get(AdapterName)"></span><span class="lv-live-text">Ethernet</span><span type="end"></span>" -ServerAddresses ("<span query="get(DNSAddresses.0)"></span><span class="lv-live-text">172.17.10.9</span><span type="end"></span>","<span query="get(DNSAddresses.1)"></span><span class="lv-live-text">8.8.8.8</span><span type="end"></span>")


## IP eta DNS **automatikoki** (DHCP)

> [!PowerShell] PowerShell
> New-NetIPAddress -InterfaceAlias "<span query="get(AdapterName)"></span><span class="lv-live-text">Ethernet</span><span type="end"></span>" -Dhcp Enabled
> 
> 
> Set-DnsClientServerAddress -InterfaceAlias "<span query="get(AdapterName)"></span><span class="lv-live-text">Ethernet</span><span type="end"></span>" -ResetServerAddresses

```powershell title:"Remove static IP address"
Get-NetIPAddress -InterfaceAlias "YourNetworkAdapterName" | Remove-NetIPAddress
```

```powershell title:"Gateway-a mantentzen bada, ruta estatikoa ezabatu behar da"
Remove-NetRoute -NextHop "192.168.1.1" -InterfaceIndex "15"
```

## HOSTNAME

```powershell title:"getHostname"
hostname
```

> [!PowerShell] PowerShell
> Rename-Computer -NewName "<span query="get(Hostname)"></span><span class="lv-live-text">server</span><span type="end"></span>" -Restart


## Active Directory instalazioa

> [!PowerShell] PowerShell
> Add-WindowsFeature -Name "ad-domain-services" -IncludeAllSubFeature -IncludeManagementTools
> 
> Add-WindowsFeature -Name "dns" -IncludeAllSubFeature -IncludeManagementTools
> 
> Add-WindowsFeature -Name "gpmc" -IncludeAllSubFeature -IncludeManagementTools

### AD sortu


> [!PowerShell] PowerShell
> Install-ADDSForest -CreateDnsDelegation:$false -DatabasePath "c:\windows\NTDS" -DomainMode "WinThreshold" -DomainName "<span query="get(DomainName)"></span><span class="lv-live-text">enpresa.eus</span><span type="end"></span>" -SafeModeAdministratorPassword (ConvertTo-SecureString "<span query="get(AdminPassword)"></span><span class="lv-live-text">Admin123*</span><span type="end"></span>" -AsPlainText -Force) -DomainNetbiosName "<span query="get(DomainNetName)"></span><span class="lv-live-text">ENPRESA</span><span type="end"></span>" -ForestMode "WinThreshold" -InstallDns:$true -LogPath "c:\windows\NTDS" -NoRebootOnCompletion:$false -SysvolPath "c:\windows\SYSVOL" -Force:$true

~~~powershell
Install-ADDSForest `
 -CreateDnsDelegation:$false `
 -DatabasePath "C:\Windows\NTDS" `
 -DomainMode "WinThreshold" `
 -DomainName "<span query="get(DomainName)"></span><span class="lv-live-text">enpresa.eus</span><span type="end"></span>" `
 -SafeModeAdministratorPassword (ConvertTo-SecureString "<span query="get(AdminPassword)"></span><span class="lv-live-text">Admin123*</span><span type="end"></span>" -AsPlainText -Force) `
 -DomainNetbiosName "<span query="get(DomainNetName)"></span><span class="lv-live-text">ENPRESA</span><span type="end"></span>" `
 -ForestMode "WinThreshold" `
 -InstallDns:$true `
 -LogPath "C:\Windows\NTDS" `
 -NoRebootOnCompletion:$false `
 -SysvolPath "C:\Windows\SYSVOL" `
 -Force:$true
~~~


