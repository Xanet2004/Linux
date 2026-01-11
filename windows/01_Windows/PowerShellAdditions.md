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
 
 # Zuhaitzaren izena (domeinu printzipalaren barruan joango da)
 $newDomainName = "newcorp.com"
 $newSubdomainName = "sales"
 
 ```

```powershell title="Active Directory"

# Active Directory zuhaitz bat sortu

$credential = Get-Credential

Install-ADDSDomain ` 
	-DomainType Tree ` 
	-NewDomainName $newDomainName ` # newcorp.com
	-ParentDomainName $domainName$ ` 
	-Credential $credential ` 
	-InstallDns:$true ` 
	-DomainMode "WinThreshold" ` 
	-SafeModeAdministratorPassword (ConvertTo-SecureString $adminPassword -AsPlainText -Force)

# Active Directory azpi-domeinu bat sortu
$credential = Get-Credential 

Install-ADDSDomain ` 
	-DomainType Child ` 
	-NewDomainName $newSubdomainName ` # sales
	-ParentDomainName $domainName ` 
	-Credential $credential ` 
	-InstallDns:$true ` 
	-DomainMode "WinThreshold" ` 
	-SafeModeAdministratorPassword (ConvertTo-SecureString $adminPassword -AsPlainText -Force
```