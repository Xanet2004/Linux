Steps to configure virtual machines once installed.
# Index
- Static IP
- OpenSSH
- Hostname

# Static IP

```powershell title="server1 - static ip"
Get-NetAdapter
# Ethernet

New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress "192.168.2.101" -PrefixLength "24" -DefaultGateway "192.168.2.1"
```

```powershell title="server2 - static ip"
Get-NetAdapter
# Ethernet

New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress "192.168.2.102" -PrefixLength "24" -DefaultGateway "192.168.2.1"
```

```powershell title="client - static ip"
Get-NetAdapter
# Ethernet

New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress "192.168.2.200" -PrefixLength "24" -DefaultGateway "192.168.2.1"
```

> Note
> If the network still is not working on client, set it with the GUI

![[client-network-staticIp.png]]

# OpenSSH

```powershell title="all machines - openssh installation"
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

Start-Service sshd
Set-Service -Name sshd -StartupType Automatic

New-NetFirewallRule `
  -Name "OpenSSH-Server-In-TCP" `
  -DisplayName "OpenSSH Server (TCP 22)" `
  -Enabled True `
  -Direction Inbound `
  -Protocol TCP `
  -Action Allow `
  -LocalPort 22
  
Get-Service sshd
```

```powershell title="server1 - connect by ssh"
ssh -p 1111 Administrator@localhost 
```

```powershell title="server2 - connect by ssh"
ssh -p 1112 Administrator@localhost 
```

```powershell title="client - connect by ssh"
ssh -p 1113 Bezeroa@localhost 
```

Ssh will be using bash by default, so we need to turn powershell on before using powershell commands.

```powershell title="turn to powershell"
powershell
```

# Hostname

Normally, we would need to restart the computers to apply hostname changes. However, since we want to take snapshots first, you can simply shut them down without restarting and then take the snapshots.

```powershell title="server1 - change hostname and restart"
Rename-Computer -NewName server1

# Restart
# Rename-Computer -NewName server1 -Restart
```

```powershell title="server2 - change hostname and restart"
Rename-Computer -NewName server2 -Restart

# Restart
# Rename-Computer -NewName server2 -Restart
```

```powershell title="client - change hostname and restart"
Rename-Computer -NewName client -Restart

# Restart
# Rename-Computer -NewName client -Restart
```

# Snapshot

```powershell title="stop computers"
Stop-Computer -Force
```

```powershell title="snapshots"
VBoxManage snapshot "server1" take "02_basicConfiguration" --description="This is the virtual machine after setting static IP, installing ssh and changing the hostname."

VBoxManage snapshot "server2" take "02_basicConfiguration" --description="This is the virtual machine after setting static IP, installing ssh and changing the hostname."

VBoxManage snapshot "client" take "02_basicConfiguration" --description="This is the virtual machine after setting static IP, installing ssh and changing the hostname."
```