DNS commands

# Installation

```powershell title="installation"
Add-WindowsFeature -Name "dns" -IncludeAllSubFeature -IncludeManagementTools
```

## Add Show and Remove DNS records

```powershell title="ad forest"
# Get records in a zone: 
Get-DnsServerResourceRecord -ZoneName "enpresa.eus" 

# Create a new A record: 
Add-DnsServerResourceRecordA -Name "www" -ZoneName "enpresa.eus" -IPv4Address "192.168.1.50" 

# Delete a record: 
Remove-DnsServerResourceRecord -ZoneName "enpresa.eus" -Name "www" -RRType "A" -Force
```

## Check DNS

In a previously created forest

```powershell title="installation"
ping www.enpresa.eus
nslookup www.enpresa.eus
nslookup enpresa.eus
```

## Delete computer DNS cache

```powershell title="installation"
ipconfig /flushdns
```

## Add Show and Remove Forward zones

```powershell title="service"
# List forward zones 
Get-DnsServerZone 

# Create a New DNS Forward Zone 
Add-DnsServerPrimaryZone -Name "enpresatest.eus" -ReplicationScope "Domain" -PassThru 

#Delete a DNS Forward Zone 
Remove-DnsServerZone -Name "enpresatest.eus" -Force
```

## Add Show and Remove Reverse zones

```powershell title="domain controller"
# List reverse lookup zones
Get-DnsServerZone 

# Create a New DNS Reverse Zone
Add-DnsServerPrimaryZone -NetworkID 192.168.1/24 -ReplicationScope Domain 

#Delete a DNS Reverse Zone 
Remove-DnsServerZone -Name "1.168.192.in-addr.arpa"
```

## Add Show and Remove Reverse zone entries

```powershell title="configured dns"
# Get Records in a Reverse Lookup Zone: 
Get-DnsServerResourceRecord -ZoneName "1.168.192.in-addr.arpa"

# Create a PTR Record (Reverse Lookup Entry) 
Add-DnsServerResourceRecordPtr -Name "100" -ZoneName "1.168.192.in-addr.arpa" -PtrDomainName "enpresa.eus" 

# Delete a PTR Record: 
Remove-DnsServerResourceRecord -ZoneName "1.168.192.in-addr.arpa" -Name "100" -RRType PTR -Force
```

## Check Reverse zone

```powershell title="dns"
nslookup 192.168.1.100
```