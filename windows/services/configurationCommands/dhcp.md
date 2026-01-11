DHCP commands

# Installation

```powershell title="installation"
Install-WindowsFeature -Name DHCP -IncludeManagementTools

# Verify
Get-WindowsFeature -Name DHCP
```

## AD Forest

```powershell title="ad forest"
# List DHCP scopes 
Get-DhcpServerv4Scope 

# Add a new DHCP scope 
Add-DhcpServerv4Scope -Name "Scope Enpresa" -StartRange "192.168.1.2" -EndRange "192.168.1.254" -SubnetMask "255.255.255.0" -State Active -Description "Primary IPv4 Scope" 

# Delete DHCP scope 
Remove-DhcpServerv4Scope -ScopeId "192.168.1.0" -Force 

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