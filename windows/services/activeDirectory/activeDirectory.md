	Configure root and child domains, organizational units, and users.

| Property             | Server 1       | Server 2           | Client  |
| -------------------- | -------------- | ------------------ | ------- |
| **Username**         | Administrator  | Administrator      | Bezeroa |
| **Hostname**         | server1        | server2            | bezeroa |
| Domain               | proiektuak.edu | pbl.proiektuak.edu | -       |
| **Active Directory** | Yes            | Yes                | No      |
# Create new AD forest and domain

```powershell title="server1 - proiektuak.edu"
Install-ADDSForest `
	-CreateDnsDelegation:$false ` 
	-DatabasePath "c:\windows\NTDS" ` 
	-DomainMode "WinThreshold" ` 
	-DomainName "proiektuak.edu" ` 
	-SafeModeAdministratorPassword (ConvertTo-SecureString "123456789aA@" -AsPlainText -Force) ` 
	-DomainNetbiosName "Proiektuak" ` 
	-ForestMode "WinThreshold" ` 
	-InstallDns:$true ` 
	-LogPath "c:\windows\NTDS" ` 
	-NoRebootOnCompletion:$false ` 
	-SysvolPath "c:\windows\SYSVOL" ` 
	-Force:$true

# The same command in one line
Install-ADDSForest -CreateDnsDelegation:$false -DatabasePath "c:\windows\NTDS" -DomainMode "WinThreshold" -DomainName "proiektuak.edu" -SafeModeAdministratorPassword (ConvertTo-SecureString "123456789aA@" -AsPlainText -Force) -DomainNetbiosName "Proiektuak" -ForestMode "WinThreshold" -InstallDns:$true -LogPath "c:\windows\NTDS" -NoRebootOnCompletion:$false -SysvolPath "c:\windows\SYSVOL" -Force:$true

# Message                          Context           RebootRequired  Status
# -------                          -------           --------------  ------
# Operation completed successfully DCPromo.General.1          False Success
```

Define our server as DNS

```powershell title="server1 - set dns"
Set-DnsClientServerAddress `
  -InterfaceAlias "Ethernet" `
  -ServerAddresses 8.8.8.8 # For outside connectivity
```

```powershell title="server1 - test ad"
nslookup proiektuak.edu
# Server:  UnKnown
# Address:  ::1
# 
# Name:    proiektuak.edu
# Address:  192.168.2.101
```

# Create child domain

Set server1 as dns server

```powershell title="server2 - set dns"
Set-DnsClientServerAddress `
  -InterfaceAlias "Ethernet" `
  -ServerAddresses 192.168.2.101
```

```powershell title="server2 - test ad"
nslookup proiektuak.edu
# DNS request timed out.
#     timeout was 2 seconds.
# Server:  UnKnown
# Address:  192.168.2.101
# 
# Name:    proiektuak.edu
```

Create child domain

```powershell title="server2 - pbl.proiektuak.edu"
# get credentials
$cred = New-Object System.Management.Automation.PSCredential("Administrator@proiektuak.edu", (ConvertTo-SecureString "123456789aA@" -AsPlainText -Force))

Install-ADDSDomain `
  -DomainType ChildDomain `
  -ParentDomainName "proiektuak.edu" `
  -NewDomainName "pbl" `
  -Credential $cred `
  -InstallDns:$true `
  -SafeModeAdministratorPassword (ConvertTo-SecureString "123456789aA@" -AsPlainText -Force) `
  -Force:$true

# The same command in one line
Install-ADDSDomain -DomainType ChildDomain -ParentDomainName "proiektuak.edu" -NewDomainName "pbl" -Credential $cred -InstallDns:$true -SafeModeAdministratorPassword (ConvertTo-SecureString "123456789aA@" -AsPlainText -Force) -Force:$true

# Message                          Context           RebootRequired  Status
# -------                          -------           --------------  ------
# Operation completed successfully DCPromo.General.1          False Success
```

```powershell title="server2 - test ad"
nslookup proiektuak.edu
# Server:  UnKnown
# Address:  ::1
# 
# Non-authoritative answer:
# Name:    proiektuak.edu
# Address:  192.168.2.101

nslookup pbl.proiektuak.edu
# Server:  UnKnown
# Address:  ::1
# 
# Name:    pbl.proiektuak.edu
# Address:  192.168.2.102
```

```powershell title="server1 - test ad"
nslookup proiektuak.edu
# Server:  UnKnown
# Address:  ::1
# 
# Name:    proiektuak.edu
# Address:  192.168.2.101

nslookup pbl.proiektuak.edu
# Server:  UnKnown
# Address:  ::1
# 
# Non-authoritative answer:
# Name:    pbl.proiektuak.edu
# Address:  192.168.2.102
```

# Snapshot

```powershell title="stop computers"
Stop-Computer -Force
```

```powershell title="snapshots"
VBoxManage snapshot "server1" take "04_adDomains" --description="This is the virtual machine after creating proiektuak.edu."

VBoxManage snapshot "server2" take "04_adDomains" --description="This is the virtual machine after creating pbl.proiektuak.edu."
```

# SSH

> Note
> Now we can connect to the machines in different ways:

```powershell title="ssh"
# Server1 - Administrator
ssh -p 1111 Proiektuak\Administrator@localhost
ssh -p 1111 Administrator@localhost

# Server2 - Administrator
ssh -p 1112 Proiektuak\Administrator@localhost
ssh -p 1112 Administrator@localhost
```