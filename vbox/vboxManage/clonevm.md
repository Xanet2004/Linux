Clone a virtual machine.

## Example
```powershell
VBoxManage clonevm "zaldua1zerb1" --basefolder "C:\Users\xanet\VirtualBox VMs\Linux\xanet-zaldua" --groups "/bigarren-eraikina" --name "zaldua2zerb1" --snapshot "01_basicConfiguration" --register
```

## Command Options

```powershell title="VBox help"
VBoxManage clonevm <vmname|uuid> [--basefolder=basefolder] [--groups=group,...] [--mode=machine | --mode=machinechildren | --mode=all] [--name=name]
      [--options=option,...] [--register] [--snapshot=snapshot-name] [--uuid=uuid]
```

# Cloning a VM for a Secondary Server

### 1. MAC nad network interfaces
    
- **MAC address**: VirtualBox usually generates a new MAC automatically, but if the clone keeps the same MAC, it can cause DHCP conflicts.  
    You can force a new MAC with:

```powershell title="new macs and network"
VBoxManage modifyvm "zaldua2zerb1" --macaddress1 000102030201 --macaddress7 000102030207 --intnet7="zaldua2"
```

- **Network interfaces**: You might also need to disable or modify some interfaces
```powershell title="disabling interfaces"
VBoxManage modifyvm "zaldua2zerb1" --nic8 none
```

- If using NAT port redirections:
```powershell title="NAT port redirections"
VBoxManage modifyvm "zaldua2zerb1" --natpf1 delete ssh
VBoxManage modifyvm "zaldua2zerb1" --natpf1 "ssh,tcp,,2223,,22"
```

### 2. Hostname

- Change the **host name** of the cloned VM:

```powershell title="change hostname"
hostname zaldua2zerb1
nano /etc/hostname
```

```powershell title="/etc/hostname"
zaldua2zerb1
```

```powershell title="change hostname"
nano /etc/hosts
```

```powershell title="/etc/hosts"
127.0.0.1   localhost
127.0.0.1   zaldua1zerb1 # Change this host name
...
```

### IP configuration

- **Static IP**: If the original VM has a fixed IP, **change it on the clone**.  
    Two machines with the same IP will cause network conflicts.
    
```powershell title="change static ip"
nano /etc/network/interfaces
```

```powershell title="/etc/network/interfaces"
# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
allow-hotplug enp0s3
iface enp0s3 inet dhcp
# This is an autoconfigured IPv6 interface
allow-hotplug enp0s18
iface enp0s18 inet static
   address 192.168.44.5/23
   gateway 192.168.44.2
```