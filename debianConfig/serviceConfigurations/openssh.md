First we need to have access to the internet, so check out: [networkInterfaces](debianConfig/serviceConfigurations/networkInterfaces)

# Port redirections

To connect to the machine via ssh, we need to define some redirections.

We have two methods for this:
1. [NAT Port forwarding](vbox/vboxManage/modifyvm)
2. [NAT Network Port forwarding](vbox/vboxManage/natnetwork)

# Installation

```powershell
apt update
apt install openssh-server
systemctl status ssh
```

# Connection

```powerhsell
ssh -p 2222 user@localhost
```

If you get a "host identification has changed" warning, remove the old saved key

```powershell
ssh-keygen -R "[localhost]:2222"
```