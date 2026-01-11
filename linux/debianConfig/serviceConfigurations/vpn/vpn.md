vpn description sentence

# Index
1. [Computer to Computer](/linux/debianConfig/serviceConfigurations/vpn/computerToComputer.md) - p2p, no encripted
2. [Computer to Computer Encrypted](/linux/debianConfig/serviceConfigurations/vpn/computerToComputerEncrypted.md) - subnet, encrypted, no Certificate Authority
3. [Computer to Network (Router)](/linux/debianConfig/serviceConfigurations/vpn/computerToNetwork.md) - subnet, encrypted, no Certificate Authority
4. [Network (Router) to Network (Router)](/linux/debianConfig/serviceConfigurations/vpn/networkToNetwork.md) - subnet, encrypted, no Certificate Authority

# Installation

```powershell title="installation"
apt install openvpn
```

# Basic configuration

Turn OpenVPN into a service

```powershell title="/etc/systemd/system/ovpn.service"
[Unit] 
 Description=OpenVPN server 
 After=network.target auditd.service 

[Service] 
 Type=simple 
 Restart=always 
 RestartSec=1 
 ExecStart=/usr/sbin/openvpn --config 

[Install] 
 WantedBy=multi-user.target
```

```powershell title="start service"
systemctl enable ovpn
systemctl start ovpn
```

# Follow up with your VPN configuration

Choose the VPN configuratin you need:

1. [Computer to Computer](/linux/debianConfig/serviceConfigurations/vpn/computerToComputer.md) - p2p, no encripted
2. [Computer to Computer Encrypted](/linux/debianConfig/serviceConfigurations/vpn/computerToComputerEncrypted.md) - subnet, encrypted, no Certificate Authority
3. [Computer to Network (Router)](/linux/debianConfig/serviceConfigurations/vpn/computerToNetwork.md) - subnet, encrypted, no Certificate Authority
4. [Network (Router) to Network (Router)](/linux/debianConfig/serviceConfigurations/vpn/networkToNetwork.md) - subnet, encrypted, no Certificate Authority