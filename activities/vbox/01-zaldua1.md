 This activity is a general view and learning about all the subject.
 I will try making a basic connection between two servers, dhcp master and client and dns master and client.
 Maybe we could see more linux services such us apache, smb, ...

# General view

## Servers
zaldua1zerb1
- addr0: auto (nat)
- addr1: 192.168.42.4/23
- addr2: 192.168.44.4/23
- dhcp: primary
- dns: master
- Machine configuration:
	- memmory: 2048
	- cpus: 2
	- NIC1 -> nat | mac: 000102030101
	- NIC7 -> intnet: zaldua1 | mac: 000102030107
	- NIC8 -> intent: zaldua2 | mac: 000102030108
	- Medium: Will be using zerbitzaria.vdi created by #iñakigaritano for the KP1-2025 (I might create and use another disks on another activity)
		- Or that was the intention but god knows what's the password to the root user so we are creating our own disk and installing the machine.
	- Partitions: (I won't look much this part for now)
		- primary / y logical swap

zaldua2zerb1
- addr0: auto (nat)
- addr1: 192.168.44.5/23
- dhcp: secondary
- dns: slave
- Machine configuration:
	- NIC1 -> nat | mac: 000102030201
	- NIC7 -> intent: zaldua2 | mac: 000102030207
	- Medium: 
		- cloned medium
	- Partitions:
		- cloned

## Clients
zaldua1bez1
- addr0: auto (nat)
- addr1: 192.168.42.10/23 -> zaldua1
- dhcp: client - zaldua1zerb1
- dns: client - zaldua1zerb1
- Machine configuration:
	- memmory: 2048
	- cpus: 2
	- NIC1 -> nat | mac: 000102031101
	- NIC7 -> intnet: zaldua1 | mac: 000102030117
	- Medium: 
		- 20GB HDD disk
	- Partitions: (I won't look much this part for now)
		- primary / y logical swap

zaldua2bez1
- addr0: auto (nat)
- addr1: 192.168.44.10/23 -> zaldua2
- dhcp: client - zaldua2zerb1
- dns: client - zaldua2zerb1
- Machine configuration:
	- memmory: 2048
	- cpus: 2
	- NIC1 -> nat | mac: 000102031201
	- NIC7 -> intnet: zaldua1 | mac: 000102030217
	- Medium: 
		- 20GB HDD disk
	- Partitions: (I won't look much this part for now)
		- primary / y logical swap
# Network info

Masc: /23 -> 8 + 8 + 7 + 0
11111111.11111111.11111110.00000000
Masc: 255.255.254.0

zaldua1: 192.168.42.0/23
	First: 192.168.42.1 (gateway / vbox gateway: 192.168.42.2)
	Last: 192.168.43.254
	Broadcast: 192.168.43.255

zaldua2: 192.168.44.0/23
	First: 192.168.44.1 (gateway / vbox gateway: 192.168.44.2)
	Last: 192.168.45.254
	Broadcast: 192.168.45.255

# Used vbox commands

We will create zaldua1zerb1 and then clone it. This way, we don't need to make through the installation process for every machine.

```powershell title="network"
# NETWORK CONF
# network creation
VBoxManage natnetwork add --netname "zaldua1" --network "192.168.42.0/23"
VBoxManage natnetwork add --netname "zaldua2" --network "192.168.44.0/23"

natnetwork start --netname "zaldua1"
natnetwork start --netname "zaldua2"
```

```powershell title="zaldua1zerb1"
# MACHINE CONF
# zaldua1zerb1
VBoxManage createvm --name "zaldua1zerb1" --ostype "Debian_64" --register --basefolder "C:\Users\xanet\VirtualBox VMs\Linux\xanet-zaldua" --groups "/eraikin-nagusia"

# Basic conf
VBoxManage modifyvm "zaldua1zerb1" --memory 2048 --cpus 2

# NICs
VBoxManage modifyvm "zaldua1zerb1" --nic1 nat --mac-address1 000102030101
vboxmanage modifyvm "zaldua1zerb1" --nic7 intnet --mac-address7 000102030107 --intnet7="zaldua1"
vboxmanage modifyvm "zaldua1zerb1" --nic8 intnet --mac-address8 000102030108 --intnet8="zaldua2"

# ISO controller
VBoxManage storagectl "zaldua1zerb1" --name "IDE" --add ide --controller PIIX4

# HDD controller
VBoxManage storagectl "zaldua1zerb1" --name "SATA" --add sata --controller IntelAhci --portcount 1  # we could use a higher port number to attach more than one disks

# ISO attach
VBoxManage storageattach "zaldua1zerb1" --storagectl "IDE" --port 0 --device 0 --type dvddrive --medium "C:\Users\xanet\SynologyDrive\Study\Mondragon\3. urtea\AzpiegiturakEtaSistemak\ISO\debian-13.2.0-amd64-netinst.iso"

# Create medium
VBoxManage createmedium disk --filename "C:\Users\xanet\VirtualBox VMs\Linux\xanet-zaldua\eraikin-nagusia\zaldua1zerb1\zaldua1zerb1-disk" --size "120000" --format VDI
# HDD attach
VBoxManage storageattach "zaldua1zerb1" --storagectl "SATA" --port 0 --device 0 --type hdd --medium "C:\Users\xanet\VirtualBox VMs\Linux\xanet-zaldua\eraikin-nagusia\zaldua1zerb1\zaldua1zerb1-disk.vdi"


# PORT REDIRECTION
VBoxManage modifyvm "zaldua1zerb1" --natpf1 "ssh,tcp,,2222,,22"


# SNAPSHOT
VBoxManage snapshot "zaldua1zerb1" take "00_beforeInitialisation" --description="This is the virtual machine before starting it for the first time."


# RUN
VBoxManage startvm "zaldua1zerb1"
```

```powershell title="zaldua1bez1"
# MACHINE CONF
# zaldua1zerb1
VBoxManage createvm --name "zaldua1bez1" --ostype "Debian_64" --register --basefolder "C:\Users\xanet\VirtualBox VMs\Linux\xanet-zaldua" --groups "/eraikin-nagusia"

# Basic conf
VBoxManage modifyvm "zaldua1bez1" --memory 2048 --cpus 2

# NIC
vboxmanage modifyvm "zaldua1bez1" --nic1 none
vboxmanage modifyvm "zaldua1bez1" --nic7 intnet --mac-address7 000102030117 --intnet7="zaldua1"

# ISO controller
VBoxManage storagectl "zaldua1bez1" --name "IDE" --add ide --controller PIIX4

# HDD controller
VBoxManage storagectl "zaldua1bez1" --name "SATA" --add sata --controller IntelAhci --portcount 1  # we could use a higher port number to attach more than one disks

# ISO attach
VBoxManage storageattach "zaldua1bez1" --storagectl "IDE" --port 0 --device 0 --type dvddrive --medium "C:\Users\xanet\SynologyDrive\Study\Mondragon\3. urtea\AzpiegiturakEtaSistemak\ISO\debian-13.2.0-amd64-netinst.iso"

# Create medium
VBoxManage createmedium disk --filename "C:\Users\xanet\VirtualBox VMs\Linux\xanet-zaldua\eraikin-nagusia\zaldua1bez1\zaldua1bez1-disk" --size "120000" --format VDI
# HDD attach
VBoxManage storageattach "zaldua1bez1" --storagectl "SATA" --port 0 --device 0 --type hdd --medium "C:\Users\xanet\VirtualBox VMs\Linux\xanet-zaldua\eraikin-nagusia\zaldua1bez1\zaldua1bez1-disk.vdi"


# SNAPSHOT
VBoxManage snapshot "zaldua1bez1" take "00_beforeInitialisation" --description="This is the virtual machine before starting it for the first time."


# RUN
VBoxManage startvm "zaldua1bez1"
```

# Server configuration

Commands used to set up the project

## Basic configuration

```powershell title="terminal - snapshot"
VBoxManage snapshot "zaldua1zerb1" take "00_1_afterInstallation" --description="Machine successfully configured."
```

```powershell title="zaldua1zerb1 - /etc/network/interfaces"
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
allow-hotplug enp0s3
iface enp0s3 inet dhcp
# This is an autoconfigured IPv6 interface
allow-hotplug enp0s18
iface enp0s18 inet static
   address 192.168.42.4/23

allow-hotplug enp0s19
iface enp0s19 inet static
   address 192.168.44.4/23
```

```powershell title="zaldua1zerb1 - reset networking"
systemctl restart networking
ip a
```

```powershell title="zaldua1zerb1 - ssh install"
apt update
apt install openssh-server
systemctl status ssh
```

```powershell title="terminal - ssh connect"
ssh -p 2222 user@localhost
```

```powershell title="terminal - snapshot"
VBoxManage snapshot "zaldua1zerb1" take "01_basicConfiguration" --description="Network interfaces and ssh installed."
VBoxManage snapshot "zaldua1bez1" take "01_installed" --description="Machine installed."
```

## Clone
### Clone zaldua1zerb1 -> zaldua2zerb1

```powershell title="terminal - clone"
VBoxManage clonevm "zaldua1zerb1" --basefolder "C:\Users\xanet\VirtualBox VMs\Linux\xanet-zaldua" --groups "/bigarren-eraikina" --name "zaldua2zerb1" --snapshot "01_basicConfiguration" --register
```

```powershell title="terminal - reconfigure network interfaces"
VBoxManage modifyvm "zaldua2zerb1" --macaddress1 000102030201 --macaddress7 000102030207 --intnet7="zaldua2" --nic8 none
```

```powershell title="terminal - NAT port redirections"
VBoxManage modifyvm "zaldua2zerb1" --natpf1 delete ssh
VBoxManage modifyvm "zaldua2zerb1" --natpf1 "ssh,tcp,,2223,,22"
```

```powershell title="terminal - snapshot"
VBoxManage snapshot "zaldua2zerb1" take "00_cloned" --description="Cloned from zaldua1zerb1, snapshot 01_basicConfiguration."
```

#### Change cloned configurations

```powershell title="zaldua2zerb1 - change hostname"
hostname zaldua2zerb1
nano /etc/hostname
```

```powershell title="zaldua2zerb1 - /etc/hostname"
zaldua2zerb1
```

```powershell title="zaldua2zerb1 - change hostname"
nano /etc/hosts
```

```powershell title="/etc/hosts"
127.0.0.1   localhost
127.0.0.1   zaldua2zerb1
```

```powershell title="zaldua2zerb1 - change static ip"
nano /etc/network/interfaces
```

```powershell title="zaldua2zerb1 - /etc/network/interfaces"
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
```

```powershell title="terminal - snapshot"
VBoxManage snapshot "zaldua2zerb1" take "01_basicConfiguration" --description="Changed basic configuration for zaldua2zerb1."
```

Reboot the system and you should be able to connect through ssh

### Clone zaldua1bez1 -> zaldua2bez1

```powershell title="terminal - clone"
VBoxManage clonevm "zaldua1bez1" --basefolder "C:\Users\xanet\VirtualBox VMs\Linux\xanet-zaldua" --groups "/bigarren-eraikina" --name "zaldua2bez1" --snapshot "01_installed" --register
```

```powershell title="terminal - reconfigure network interfaces"
VBoxManage modifyvm "zaldua2bez1" --macaddress7 000102030217 --intnet7="zaldua2"
```

```powershell title="terminal - snapshot"
VBoxManage snapshot "zaldua2bez1" take "00_cloned" --description="Cloned from zaldua1bez1, snapshot 01_installed."
```

#### Change cloned configurations

```powershell title="zaldua2zerb1 - change hostname"
hostname zaldua2zerb1
nano /etc/hostname
```

```powershell title="zaldua2zerb1 - /etc/hostname"
zaldua2zerb1
```

```powershell title="zaldua2zerb1 - change hostname"
nano /etc/hosts
```

```powershell title="/etc/hosts"
127.0.0.1   localhost
127.0.0.1   zaldua2zerb1
```

```powershell title="terminal - snapshot"
VBoxManage snapshot "zaldua2bez1" take "02_changedClonedConfiguration" --description="Changed basic configuration for zaldua2bez1."
```

Reboot the system and you should be able to connect through ssh
## DHCP

```powershell title="zaldua1zerb1 - installation"
apt update
apt-get install isc-dhcp-server
```

```powershell title="zaldua1zerb1 - /etc/default/isc-dhcp-server"
INTERFACESv4="enp0s18 enp0s19"  # This will be the interface that DHCP will look
INTERFACESv6=""
```

```powershell title="zaldua1zerb1 - /etc/dhcp/dhcpd.conf"
option domain-name "zaldua.eus";
option domain-name-servers 192.168.42.2, 192.168.44.4;

default-lease-time 600;
max-lease-time 7200;

failover peer "dhcp-failover" {
    primary;                    # this is the primary
    address 192.168.44.4;       # primary server IP
    port 647;                   # default failover port
    peer address 192.168.44.5;  # secondary server IP
    peer port 647;
    max-response-delay 60;
    max-unacked-updates 10;
    mclt 1800;                  # maximum client lead time
    split 128;                  # how to split IP pool (128 = 50/50)
}

# subnet 1
subnet 192.168.42.0 netmask 255.255.254.0 {
  pool {
    range 192.168.42.100 192.168.42.200;
    failover peer "dhcp-failover";
  }
  option domain-name-servers 192.168.42.4, 192.168.44.5;
  option domain-name "zalduabat.eus";
  option routers 192.168.42.2;
  option broadcast-address 192.168.43.255;
  default-lease-time 60;
  max-lease-time 720;
}

# subnet 2
subnet 192.168.44.0 netmask 255.255.254.0 {
  pool {
    range 192.168.44.100 192.168.44.200;
    failover peer "dhcp-failover";
  }
  option domain-name-servers 192.168.42.4, 192.168.44.5;
  option domain-name "zalduabat.eus";
  option routers 192.168.44.2;
  option broadcast-address 192.168.45.255;
  default-lease-time 60;
  max-lease-time 720;
}
```

```powershell title="zaldua1zerb1 - installation"
apt update
apt-get install isc-dhcp-server
```

```powershell title="zaldua2zerb1 - /etc/default/isc-dhcp-server"
INTERFACESv4="enp0s18"  # This will be the interface that DHCP will look
INTERFACESv6=""
```

```powershell title="zaldua2zerb1 - /etc/dhcp/dhcpd.conf"
option domain-name "zaldua.eus";
option domain-name-servers 192.168.42.2, 192.168.44.4;

default-lease-time 600;
max-lease-time 7200;

#authoritative; # IMPORTANT TO COMMENT THIS ON THE SECONDARY SERVER

failover peer "dhcp-failover" {
    secondary;                  # this is now the secondary
    address 192.168.44.5;       # secondary server IP
    port 647;
    peer address 192.168.44.4;  # primary server IP
    peer port 647;
    max-response-delay 60;
    max-unacked-updates 10;
}

# subnet 2
subnet 192.168.44.0 netmask 255.255.254.0 {
    pool {
      range 192.168.44.100 192.168.44.200;
      failover peer "dhcp-failover";
    }
    option domain-name-servers 192.168.42.4, 192.168.44.5;
    option domain-name "zalduabat.eus";
    option routers 192.168.44.2;
    option broadcast-address 192.168.45.255;
    default-lease-time 60;
    max-lease-time 720;
}

# subnet 1
subnet 192.168.42.0 netmask 255.255.254.0 {
    pool {
      range 192.168.42.100 192.168.42.200;
      failover peer "dhcp-failover";
    }
    option domain-name-servers 192.168.42.4, 192.168.44.5;
    option domain-name "zalduabat.eus";
    option routers 192.168.42.2;
    option broadcast-address 192.168.43.255;
    default-lease-time 60;
    max-lease-time 720;
}
```

## DNS

```powershell title="zaldua1zerb1 - installation"
apt update
apt install bind9 bind9-dnsutils
```

Estructura general:

- **zalduabat (192.168.42.0/23)**
    → `42.168.192.in-addr.arpa`
    → `43.168.192.in-addr.arpa`
    
- **zalduabi (192.168.44.0/23)**
    → `44.168.192.in-addr.arpa`  
    → `45.168.192.in-addr.arpa`

```powershell title="zaldua1zerb1 - /etc/bind/named.conf.options"
options {
	directory "/var/cache/bind";

	listen-on { any; };
	listen-on-v6 { none; };

	recursion yes;

	allow-recursion {
		localhost;
		192.168.42.0/23;
		192.168.44.0/23;
	};

	allow-query { any; };

	forwarders {
		8.8.8.8;
		1.1.1.1;
	};

	dnssec-validation auto;
};
```

```powershell title="zaldua1zerb1 - /etc/bind/named.conf.local"
// Forward zones
zone "zalduabat.eus" {
    type master;
    file "/etc/bind/zalduabat.db";
    allow-transfer { 192.168.44.5; };
};

zone "zalduabi.eus" {
    type master;
    file "/etc/bind/zalduabi.db";
    allow-transfer { 192.168.44.5; };
};

// Reverse zones zalduabat (192.168.42.0/23)
zone "42.168.192.in-addr.arpa" {
    type master;
    file "/etc/bind/db.192.168.42";
    allow-transfer { 192.168.44.5; };
};

zone "43.168.192.in-addr.arpa" {
    type master;
    file "/etc/bind/db.192.168.43";
    allow-transfer { 192.168.44.5; };
};

// Reverse zones zalduabi (192.168.44.0/23)
zone "44.168.192.in-addr.arpa" {
    type master;
    file "/etc/bind/db.192.168.44";
    allow-transfer { 192.168.44.5; };
};

zone "45.168.192.in-addr.arpa" {
    type master;
    file "/etc/bind/db.192.168.45";
    allow-transfer { 192.168.44.5; };
};
```

```powershell title="zaldua1zerb1 - /etc/bind/zalduabat.db"
$TTL 86400
@   IN  SOA serv1.zalduabat.eus. admin.zalduabat.eus. (
        1
        604800
        86400
        2419200
        86400 )

@       IN  NS  serv1.zalduabat.eus.

serv1   IN  A   192.168.42.4
client1 IN  A   192.168.42.101
```
```powershell title="zaldua1zerb1 - /etc/bind/zalduabi.db"
$TTL 86400
@   IN  SOA serv1.zalduabi.eus. admin.zalduabi.eus. (
        1
        604800
        86400
        2419200
        86400 )

@       IN  NS  serv1.zalduabi.eus.

serv1   IN  A   192.168.44.4
serv2   IN  A   192.168.44.5
client2 IN  A   192.168.44.101
```

```powershell title="zaldua1zerb1 - /etc/bind/db.192.168.42"
$TTL 86400
@   IN  SOA serv1.zalduabat.eus. admin.zalduabat.eus. (
        1
        604800
        86400
        2419200
        86400 )

@   IN  NS  serv1.zalduabat.eus.

4   IN  PTR serv1.zalduabat.eus.
101 IN  PTR client1.zalduabat.eus.
```
```powershell title="zaldua1zerb1 - /etc/bind/db.192.168.43"
$TTL 86400
@   IN  SOA serv1.zalduabat.eus. admin.zalduabat.eus. (
        1
        604800
        86400
        2419200
        86400 )

@   IN  NS  serv1.zalduabat.eus.
```

```powershell title="zaldua1zerb1 - /etc/bind/db.192.168.44"
$TTL 86400
@   IN  SOA serv1.zalduabi.eus. admin.zalduabi.eus. (
        1
        604800
        86400
        2419200
        86400 )

@   IN  NS  serv1.zalduabi.eus.

4   IN  PTR serv1.zalduabi.eus.
5   IN  PTR serv2.zalduabi.eus.
101 IN  PTR client2.zalduabi.eus.
```
```powershell title="zaldua1zerb1 - /etc/bind/db.192.168.45"
$TTL 86400
@   IN  SOA serv1.zalduabi.eus. admin.zalduabi.eus. (
        1
        604800
        86400
        2419200
        86400 )

@   IN  NS  serv1.zalduabi.eus.
```

```powershell title="zaldua2zerb1 - installation"
apt update
apt install bind9 bind9-dnsutils
```

```powershell title="creating cache for bind"
mkdir -p /var/cache/bind
chown -R bind:bind /var/cache/bind
chmod 750 /var/cache/bind
```

> Important
> We are creating this file for the secondary server to copy the zones from the primary

```powershell title="zaldua2zerb1 - /etc/bind/named.conf.options"
options {
	directory "/var/cache/bind";

	listen-on { any; };
	listen-on-v6 { none; };

	recursion yes;

	allow-recursion {
		localhost;
		192.168.42.0/23;
		192.168.44.0/23;
	};

	allow-query { any; };

	forwarders {
		8.8.8.8;
		1.1.1.1;
	};

	dnssec-validation auto;
};
```

```powershell title="zaldua2zerb1 - /etc/bind/named.conf.local"
// Forward zones
zone "zalduabat.eus" {
    type slave;
    file "/var/cache/bind/zalduabat.db";
    masters { 192.168.44.4; };
};

zone "zalduabi.eus" {
    type slave;
    file "/var/cache/bind/zalduabi.db";
    masters { 192.168.44.4; };
};

// Reverse zones zalduabat (192.168.42.0/23)
zone "42.168.192.in-addr.arpa" {
    type slave;
    file "/var/cache/bind/db.192.168.42";
    masters { 192.168.44.4; };
};

zone "43.168.192.in-addr.arpa" {
    type slave;
    file "/var/cache/bind/db.192.168.43";
    masters { 192.168.44.4; };
};

// Reverse zones zalduabi (192.168.44.0/23)
zone "44.168.192.in-addr.arpa" {
    type slave;
    file "/var/cache/bind/db.192.168.44";
    masters { 192.168.44.4; };
};

zone "45.168.192.in-addr.arpa" {
    type slave;
    file "/var/cache/bind/db.192.168.45";
    masters { 192.168.44.4; };
};
```

## LDAP

```powershell title="zaldua1zerb1 - template"

```

## WWW

```powershell title="zaldua1zerb1 - template"
```

## Docker

```powershell title="zaldua1zerb1 - template"
```

## SMB

```powershell title="zaldua1zerb1 - template"
```

## Backups (Segurtasun kopiak)

```powershell title="zaldua1zerb1 - template"
```

## Task automatisations (Ataza automatizazioa)

```powershell title="zaldua1zerb1 - template"
```

## Template

```powershell title="zaldua1zerb1 - template"
```

