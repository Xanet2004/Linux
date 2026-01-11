SSH commands

Configure Static IP and natnetwork forwardings first: [Machine configuration](/windows/machineCreation/machineCreation.md)

# 

# Installation

```powershell title="all machines - openssh installation"
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
```

# Configuration

```powershell title="all machines - openssh configuration"
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

# Connection

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