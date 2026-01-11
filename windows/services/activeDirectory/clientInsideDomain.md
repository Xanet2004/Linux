This document explains how to configure a client to join the child domain [pbl.proiektuak.edu].

# Configure DNS

To communicate properly with the child domain controller, the client must use **Server2** as its DNS server. 
This ensures it can resolve domain names in [pbl.proiektuak.edu].

```powershell title="client - configure dns"
Set-DnsClientServerAddress `
  -InterfaceAlias "Ethernet" `
  -ServerAddresses 192.168.2.102
```

# Join Client to Child Domain

Normally, we would need to restart the computers to apply domain changes. However, since we want to take snapshots first, you can simply shut them down without restarting and then take the snapshots.

```powershell title="client - join domain"
$user = "pbl\Administrator"
$pass = ConvertTo-SecureString "123456789aA@" -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential($user, $pass)

Add-Computer `
  -DomainName "pbl.proiektuak.edu" `
  -Credential $cred

# Restart
# Add-Computer `
#   -DomainName "pbl.proiektuak.edu" `
#   -Credential $cred `
#   -Restart
```

# Test

Check if client is inside the domain.

```powershell title="client - check domain"
(Get-WmiObject Win32_ComputerSystem).Domain
# pbl.proiektuak.edu
```
# Snapshot

```powershell title="stop computers"
Stop-Computer -Force
```

```powershell title="snapshots"
VBoxManage snapshot "client" take "06_adChildDomain" --description="This is the virtual machine after configuring the domain to pbl.proiektuak.edu"
```