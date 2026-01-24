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
- ldap

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
- client1.zalduabat.eus

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
- client2.zalduabat.eus -> Not zalduabi.eus because its not useful for LDAP
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

> WE WON'T CREATE A NETWORK BECAUSE WE ARE USING INET INTERFACES
# Used vbox commands

We will create zaldua1zerb1 and then clone it. This way, we don't need to make through the installation process for every machine.

```powershell title="natnetwork"
# NETWORK CONF
# natnetwork creation -> we are using inet!
#VBoxManage natnetwork add --netname "zaldua1" --network "192.168.42.0/23"
#VBoxManage natnetwork add --netname "zaldua2" --network "192.168.44.0/23"

#natnetwork start --netname "zaldua1"
#natnetwork start --netname "zaldua2"
```

```powershell title="zaldua1zerb1"
# MACHINE CONF
# zaldua1zerb1
VBoxManage createvm --name "zaldua1zerb1" --ostype "Debian_64" --register --basefolder "C:\Users\xanet\VirtualBox VMs\Linux\xanet-zaldua" --groups "/eraikin-nagusia"

# Basic conf
VBoxManage modifyvm "zaldua1zerb1" --memory 2048 --cpus 2

# NICs
VBoxManage modifyvm "zaldua1zerb1" --nic1 nat --mac-address1 000102030101
vboxmanage modifyvm "zaldua1zerb1" --nic7 intnet --mac-address7 000102030107 --intnet7 zaldua1
vboxmanage modifyvm "zaldua1zerb1" --nic8 intnet --mac-address8 000102030108 --intnet8 zaldua2

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
vboxmanage modifyvm "zaldua1bez1" --nic7 intnet --mac-address7 000102030117 --intnet7 zaldua1

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
VBoxManage modifyvm "zaldua2zerb1" --macaddress1 000102030201 --macaddress7 000102030207 --intnet7 zaldua2 --nic8 none
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
VBoxManage modifyvm "zaldua2bez1" --macaddress7 000102030217 --intnet7 zaldua2
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
option domain-name "zalduabat.eus"; # Default domain
option domain-name-servers 192.168.42.2, 192.168.44.4;

default-lease-time 600;
max-lease-time 7200;

authoritative;

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
  option domain-name "zalduabat.eus"; # Not zalduabi.eus because it doesn't have any logic
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
  option domain-name "zalduabat.eus"; # Not zalduabi.eus because it doesn't have any logic
  option routers 192.168.44.2;
  option broadcast-address 192.168.45.255;
  default-lease-time 60;
  max-lease-time 720;
}

host zaldua1bez1 { # Important to declare same hosts on both master and slave servers, could throw errors
  hardware ethernet 00:01:02:03:01:17;
  fixed-address 192.168.42.10;
}

host zaldua2bez1 {
  hardware ethernet 00:01:02:03:02:17;
  fixed-address 192.168.44.10;
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
option domain-name "zalduabat.eus"; # Default domain
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
    option domain-name "zalduabat.eus"; # Not zalduabi.eus because it doesn't have any logic
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
    option domain-name "zalduabat.eus"; # Not zalduabi.eus because it doesn't have any logic
    option routers 192.168.42.2;
    option broadcast-address 192.168.43.255;
    default-lease-time 60;
    max-lease-time 720;
}

host zaldua1bez1 { # Important to declare same hosts on both master and slave servers, could throw errors
  hardware ethernet 00:01:02:03:01:17;
  fixed-address 192.168.42.10;
}

host zaldua2bez1 {
  hardware ethernet 00:01:02:03:02:17;
  fixed-address 192.168.44.10;
}
```

## DNS

```powershell title="zaldua1zerb1 - installation"
apt update
apt install bind9 bind9-dnsutils
```

General structure:
- **zalduabat (192.168.42.0/23)**
    → `42.168.192.in-addr.arpa`
    → `43.168.192.in-addr.arpa`
    
- **zalduabi (192.168.44.0/23)**
    → `44.168.192.in-addr.arpa`  
    → `45.168.192.in-addr.arpa`
### zaldua1zerb1 as Master

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
serv2   IN  A   192.168.44.5 ; Not useful for LDAP so we are moving zalduabi clients to zalduabat
client1 IN  A   192.168.42.10
client2 IN  A   192.168.44.10 ; Not useful for LDAP so we are moving zalduabi clients to zalduabat
ldap    IN  A   192.168.42.4
www     IN  A   192.168.42.30
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
;serv2   IN  A   192.168.44.5 ; Not useful for LDAP so we are moving zalduabi clients to zalduabat
;client2 IN  A   192.168.44.10 ; Not useful for LDAP so we are moving zalduabi clients to zalduabat
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
10  IN  PTR client1.zalduabat.eus.
30  IN  PTR www.zalduabat.eus.
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
5   IN  PTR serv2.zalduabat.eus. ; Not useful for LDAP so we are moving zalduabi clients to zalduabat
10 IN  PTR client2.zalduabat.eus. ; Not useful for LDAP so we are moving zalduabi clients to zalduabat
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

Changing DHCP default DNS config for clients

```powershell title="zaldua1zerb1 - /etc/dhcp/dhcpd.conf"
option domain-name "zaldua.eus";
option domain-name-servers serv1.zalduabat.eus, serv2.zalduabi.eus;
...
```

Changing DHCP default DNS config on the server

```powershell title="zaldua1zerb1 - /etc/dhcpcd.conf"
...
interface enp0s3
static domain_name_servers=127.0.0.1 8.8.8.8
```

### zaldua2zerb1 as Slave

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

Changing DHCP default DNS config for clients

```powershell title="zaldua2zerb1 - /etc/dhcp/dhcpd.conf"
option domain-name "zaldua.eus";
option domain-name-servers serv1.zalduabat.eus, serv2.zalduabi.eus;
...
```

Changing DHCP default DNS config on the server

```powershell title="zaldua2zerb1 - /etc/dhcpcd.conf"
...
interface enp0s3
static domain_name_servers=192.168.44.4 127.0.0.1 8.8.8.8
```

## Routing

Some vms don't have access to the internet. This is because they need a nat interface OR a router with outside access.
This is why we are defining zaldua1zerb1 as router.

```powershell title="zaldua1zerb1 - installation"
apt install iptables iptables-persistent
```

```powershell title="zaldua1zerb1"
nano /etc/sysctl.conf
```

```powershell title="zaldua1zerb1 - /etc/sysctl.conf"
net.ipv4.ip_forward = 1 # 1 -> Turn forwarding on persistently
```

> Important
> Seems that in new debian machines this file just doesn't work. We need to configure the next one:

```powershell title="zaldua1zerb1"
nano /etc/sysctl.d/99-ipforward.conf
```

```powershell title="zaldua1zerb1 - /etc/sysctl.d/99-ipforward.conf"
net.ipv4.ip_forward = 1 # 1 -> Turn forwarding on persistently
```

```powershell title="zaldua1zerb1"
systemctl enable systemd-sysctl
systemctl start systemd-sysctl
sysctl -p # Update changes
```

```powershell title="zaldua1zerb1 - Nat and forward rules"
# Masquerade traffic coming from the 192.168.42.0/23 network
# This rewrites the source IP to the IP of enp0s3 (Internet-facing interface)
iptables -t nat -A POSTROUTING -s 192.168.42.0/23 -o enp0s3 -j MASQUERADE

# Masquerade traffic coming from the 192.168.44.0/23 network
# This allows hosts in this subnet to access the Internet
iptables -t nat -A POSTROUTING -s 192.168.44.0/23 -o enp0s3 -j MASQUERADE


# Allow forwarding of packets from internal network 192.168.42.0/23 to the Internet
iptables -A FORWARD -s 192.168.42.0/23 -o enp0s3 -j ACCEPT

# Allow forwarding of packets from internal network 192.168.44.0/23 to the Internet
iptables -A FORWARD -s 192.168.44.0/23 -o enp0s3 -j ACCEPT

# Allow return traffic for already established or related connections
# This is required so replies from the Internet are accepted
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

# Save
netfilter-persistent save
```

Define server1 as gateway router

```powershell title="zaldua1zerb1 - /etc/network/interfaces"
allow-hotplug enp0s18
iface enp0s18 inet static
   address 192.168.44.5/23
   gateway 192.168.44.2 # Outside Router ip
```

```powershell title="zaldua2zerb1 - /etc/network/interfaces"
allow-hotplug enp0s18
iface enp0s18 inet static
   address 192.168.44.5/23
   gateway 192.168.44.4 # Server1 as router
```

```powershell title="zaldua1zerb1 - /etc/dhcp/dhcpd.conf"
...
option routers 192.168.42.4; # zaldua1zerb1 as router on every zone configurations
...
option routers 192.168.44.4; # zaldua1zerb1 as router on every zone configurations
...
```

```powershell title="zaldua2zerb1 - /etc/dhcp/dhcpd.conf"
...
option routers 192.168.42.4; # zaldua1zerb1 as router on every zone configurations
...
option routers 192.168.44.4; # zaldua1zerb1 as router on every zone configurations
...
```

```powershell title="secondary server - persistent routers - /etc/network/interfaces"
allow-hotplug enp0s18
iface enp0s18 inet static
   address 192.168.44.5/23
   gateway 192.168.44.4 # zaldua1zerb1 as router
   up ip route add 192.168.42.0/23 via 192.168.44.4
   # For devices going to 192.168.42.0 go through 192.168.44.4
```

## LDAP

```powershell title="zaldua1zerb1 - installation"
apt update
apt install slapd ldap-utils
```

```powershell title="zaldua1zerb1 - basic ldap conf"
dpkg-reconfigure slapd
> No
> zalduabat.eus
> zaldua
> admin passwd
> No
> Yes

systemctl restart slapd

slapcat # see domain users / entities
```

```powershell title="zaldua1zerb1 - add user"
mkdir /root/ldap/
nano /root/ldap/add_content.ldif
```

```powershell title="zaldua1zerb1 - /root/ldap/add_content.ldif"
# Add People OU
dn: ou=People,dc=zalduabat,dc=eus
objectClass: organizationalUnit
ou: People

# Add Xanet user
dn: uid=xzaldua,ou=People,dc=zalduabat,dc=eus
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: shadowAccount
uid: xzaldua
cn: Xanet Zaldua
sn: Zaldua
givenName: Xanet
displayName: Xanet Zaldua
uidNumber: 10000
gidNumber: 5000
homeDirectory: /home/xzaldua
loginShell: /bin/bash
userPassword: xzaldua
gecos: Xanet Zaldua
```

```powershell title="zaldua1zerb1 - generate user"
ldapadd -x -D cn=admin,dc=zalduabat,dc=eus -W -f /root/ldap/add_content.ldif
# cn = creators name
```

```powershell title="server - see domain entities"
slapcat
```

LDAP server is configured, so we need to install it on the clients now.

```powershell title="all clients - installing ldap"
apt install libnss-ldapd libpam-ldapd ldap-utils
> ldap://ldap.zalduabat.eus
> dc=zalduabat,dc=eus
> passwd, group, shadow
```

```powershell title="all clients - /etc/pam.d/common-session"
...
session required pam_mkhomedir.so umask=0022 skel=/etc/skel
```

## WWW

```powershell title="zaldua1zerb1 - installation"
apt update
apt install apache2
```

```powershell title="zaldua1zerb1 - add ip"
ip address add 192.168.42.30/24 dev enp0s18
```

```powershell title="create folder"
mkdir /var/www/zalduabat
```

```powershell title="/var/www/zalduabat/index.html"
<html>
	<head>
		<title>www.zalduabat.eus</title>
	</head>
	<body>
		<center>www.zalduabat.eus</center>
	</body>
</html>
```

Create a conf file

```powershell title="conf file"
nano /etc/apache2/sites-available/zalduabat.conf
```

```powershell title="/etc/apache2/sites-available/zalduabat.conf"
<VirtualHost *:80>
	ServerName www.zalduabat.eus
	
	ServerAdmin webmaster@zalduabat.eus
	DocumentRoot /var/www/zalduabat
	
	ErrorLog ${APACHE_LOG_DIR}/error.log
	CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```

```powershell title="enable new page"
a2ensite zalduabat.conf
```

```powershell title="disable"
systemctl reload apache2
```

Now we want to get an https certificate for our page.

```powershell title="zaldua1zerb1 - create folder"
mkdir /etc/apache2/ssl
```

```powershell title="zaldua1zerb1 - generate certificate"
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/apache2/ssl/apache.key -out /etc/apache2/ssl/apache.crt
```

It doesn't matter how you answer the questions. But is more reliable for people if you do it well.

```powershell title="zaldua1zerb1 - /etc/apache2/sites-available/zalduabat-ssl.conf"
<IfModule mod_ssl.c>
	<VirtualHost *:443>
		ServerName www.zalduabat.eus
		
		ServerAdmin webmaster@zalduabat.eus
		DocumentRoot /var/www/zalduabat
		
		SSLEngine on
		SSLCertificateFile    /etc/apache2/ssl/apache.crt
		SSLCertificateKeyFile /etc/apache2/ssl/apache.key
		
		ErrorLog ${APACHE_LOG_DIR}/error.log
		CustomLog ${APACHE_LOG_DIR}/access.log combined
	</VirtualHost>
</IfModule>
```

```powershell title="zaldua1zerb1 - enable ssl module"
a2enmod ssl
```

```powershell title="zaldua1zerb1 - enable new page"
a2ensite zalduabat.conf
```

```powershell title="zaldua1zerb1 - reload website"
systemctl reload apache2
```

## Docker

```powershell title="installation - repository"
apt update
apt install apt-transport-https ca-certificates curl gnupg lsb-release ## Install needed packages to add the new repository from where we are going to install docker.
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
```

```powershell title="installation - docker"
apt update
apt install docker-ce docker-ce-cli containerd.io
```

```powershell title="add user to docker"
adduser user docker
```

```powershell title="change default network - /etc/docker/daemon.json"
{ # This is an internal network that docker will be using
	"bip": "172.18.0.1/24",
	"fixed-cidr": "172.18.0.0/24"
}
```

```powershell title="restart system"
reboot
```

> Important
> Configure this as user, not root

```powershell title="create folders as user"
mkdir -p /home/user/containers/dockerfiles
mkdir -p /home/user/containers/apache2/www/zalduabat
mkdir /home/user/containers/apache2/ssl
```

```powershell title="create dockerfile - /home/user/containers/dockerfiles/Dockerfile"
FROM debian:bookworm-slim

LABEL maintainer "Xanet Zaldua <xzaldua@zalduabat.edu>"

RUN apt-get update && apt-get install -qqy apache2 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENTRYPOINT ["/usr/sbin/apachectl"]
CMD ["-D", "FOREGROUND"]
```

> Important
> We are creating a docker container for apache2 service.

```powershell title="generate image"
docker build -t apache2 /home/user/containers/dockerfiles
```

```powershell title="see images"
docker images
```

```powershell title="run container"
docker run -d --rm --name apache2 apache2
```

```powershell title="running containers"
docker ps
```

## SMB

```powershell title="create user for smb"
useradd -m -s /bin/bash oierico # example user named oierico
passwd oierico
```

```powershell title="installation"
apt update
apt install cifs-utils samba
```

```powershell title="create shared folder"
mkdir /home/oierico/shared
```

```powershell title="/etc/samba/smb.conf"
[shared]
 comment = Shared directory for oierico
 browseable = no
 path = /home/oierico/shared
 read only = no
 writeable = yes
 create mask = 0700
 directory mask = 0700
 valid users = oierico
```

```powershell title="add user to smb database"
smbpasswd -a oierico
systemctl restart smbd
```

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

