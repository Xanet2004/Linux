
```powershell title="inet disable dhcp / remove inets"
VBoxManage dhcpserver remove --netname zaldua1
VBoxManage dhcpserver remove --netname zaldua2
```

```powershell title="zerbitzaria1"
# MACHINE CONF
# zerbitzaria1
VBoxManage createvm --name "zerbitzaria1" --ostype "Debian_64" --register --basefolder "C:\Users\xanet\VirtualBox VMs\Linux\xanet-zaldua" --groups "/kptest"

# Basic conf
VBoxManage modifyvm "zerbitzaria1" --memory 2048 --cpus 2

# NICs
VBoxManage modifyvm "zerbitzaria1" --nic1 nat --mac-address1 000102030101
vboxmanage modifyvm "zerbitzaria1" --nic7 intnet --mac-address7 000102030107 --intnet7 zaldua1
vboxmanage modifyvm "zerbitzaria1" --nic8 intnet --mac-address8 000102030108 --intnet8 zaldua2

# ISO controller
#VBoxManage storagectl "zerbitzaria1" --name "IDE" --add ide --controller PIIX4

# HDD controller
VBoxManage storagectl "zerbitzaria1" --name "SATA" --add sata --controller IntelAhci --portcount 1  # we could use a higher port number to attach more than one disks

# ISO attach
#VBoxManage storageattach "zerbitzaria1" --storagectl "IDE" --port 0 --device 0 --type dvddrive --medium "C:\Users\xanet\SynologyDrive\Study\Mondragon\3. urtea\AzpiegiturakEtaSistemak\ISO\debian-13.2.0-amd64-netinst.iso"

# Create medium
#VBoxManage createmedium disk --filename "C:\Users\xanet\VirtualBox VMs\Linux\xanet-zaldua\kptest\zerbitzaria1\zerbitzaria1-disk" --size "120000" --format VDI
# HDD attach
VBoxManage storageattach "zerbitzaria1" --storagectl "SATA" --port 0 --device 0 --type hdd --medium "C:\Users\xanet\Temp\zerbitzaria.vdi"


# PORT REDIRECTION
VBoxManage modifyvm "zerbitzaria1" --natpf1 "ssh,tcp,,2222,,22"


# SNAPSHOT
VBoxManage snapshot "zerbitzaria1" take "00_beforeInitialisation" --description="This is the virtual machine before starting it for the first time."


# RUN
VBoxManage startvm "zerbitzaria1"
```

```powershell title="kptestbez1"
# MACHINE CONF
# zerbitzaria1
VBoxManage createvm --name "kptestbez1" --ostype "Debian_64" --register --basefolder "C:\Users\xanet\VirtualBox VMs\Linux\xanet-zaldua" --groups "/kptest"

# Basic conf
VBoxManage modifyvm "kptestbez1" --memory 2048 --cpus 2

# NIC
vboxmanage modifyvm "kptestbez1" --nic1 nat --mac-address1 000102030111
vboxmanage modifyvm "kptestbez1" --nic7 intnet --mac-address7 000102030117 --intnet7 zaldua1

# ISO controller
VBoxManage storagectl "kptestbez1" --name "IDE" --add ide --controller PIIX4

# HDD controller
VBoxManage storagectl "kptestbez1" --name "SATA" --add sata --controller IntelAhci --portcount 1  # we could use a higher port number to attach more than one disks

# ISO attach
VBoxManage storageattach "kptestbez1" --storagectl "IDE" --port 0 --device 0 --type dvddrive --medium "C:\Users\xanet\SynologyDrive\Study\Mondragon\3. urtea\AzpiegiturakEtaSistemak\ISO\debian-13.2.0-amd64-netinst.iso"

# Create medium
VBoxManage createmedium disk --filename "C:\Users\xanet\VirtualBox VMs\Linux\xanet-zaldua\kptest\kptestbez1\kptestbez1-disk" --size "120000" --format VDI
# HDD attach
VBoxManage storageattach "kptestbez1" --storagectl "SATA" --port 0 --device 0 --type hdd --medium "C:\Users\xanet\VirtualBox VMs\Linux\xanet-zaldua\kptest\kptestbez1\kptestbez1-disk.vdi"

# PORT REDIRECTION
VBoxManage modifyvm "kptestbez1" --natpf1 "ssh,tcp,,2223,,22"

# SNAPSHOT
VBoxManage snapshot "kptestbez1" take "00_beforeInitialisation" --description="This is the virtual machine before starting it for the first time."


# RUN
VBoxManage startvm "kptestbez1"
```

# Server1 config

1. dhcp
2. dns
3. smb
4. apache2

```powershell title="network"
# network/interfaces
auto lo
iface lo inet loopback

auto enp0s3
iface enp0s3 inet dhcp

auto enp0s18
iface enp0s18 inet static
   address 192.168.42.4/23

auto enp0s19
iface enp0s19 inet static
   address 192.168.44.4/23

#terminal
systemctl restart networking
```

```powershell title="network"
# terminal
systemctl status isc-dhcp-server  # -> Inactive

nano /etc/bind/named.conf.options # -> Still not configured
nano /etc/bind/named.conf.local   # -> Still not configured

nano /etc/samba/smb.conf # -> Still not configured

nano /etc/apache2/sites-available/ # -> Still not configured
#000-default.conf  default-ssl.conf
```

# ADIBIDE ARIKETA

```powershell title="dhcp"
nano /etc/default/isc-dhcp-server
INTERFACESv4="enp0s18 enp0s19"

nano /etc/dhcp/dhcpd.conf

# subnet 1
subnet 192.168.42.0 netmask 255.255.254.0 {
  pool {
    range 192.168.42.100 192.168.42.200;
    #failover peer "dhcp-failover";
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
    #failover peer "dhcp-failover";
  }
  option domain-name-servers 192.168.42.4, 192.168.44.5;
  option domain-name "zalduabat.eus"; # Not zalduabi.eus because it doesn't have any logic
  option routers 192.168.44.2;
  option broadcast-address 192.168.45.255;
  default-lease-time 60;
  max-lease-time 720;
}
```

> Note
> If necessary, change nameserver on dhcpcd.conf:
> 
> interface enp0s3
> static domain_name_servers=static domain_name_servers=127.0.0.1 8.8.8.8

```powershell title="dns"
nano /etc/bind/named.conf.options

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


nano /etc/bind/named.conf.local

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


nano /etc/bind/zalduabat.db
$TTL 86400
@   IN  SOA serv1.zalduabat.eus. admin.zalduabat.eus. (
        1
        604800
        86400
        2419200
        86400 )

@       IN  NS  serv1.zalduabat.eus.

serv1   IN  A   192.168.42.4
www     IN  A   192.168.42.30
smb     IN  A   192.168.42.4
client1 IN  A   192.168.42.101

nano /etc/bind/zalduabi.db
$TTL 86400
@   IN  SOA serv1.zalduabi.eus. admin.zalduabi.eus. (
        1
        604800
        86400
        2419200
        86400 )

@       IN  NS  serv1.zalduabi.eus.

serv1   IN  A   192.168.44.4
```

> Note
> Reverses are not completely necessary

```powershell title="localhost as dns before nat enp0s3"
nano /etc/dhcpcd.conf

interface enp0s3
static domain_name_servers=127.0.0.1 8.8.8.8
```

Restart all services and it should work fine

```powershell title="smb"
exit # -> as user
mkdir /home/user/shared

su - # -> changed to root again xD | User cant edit the file

nano /etc/samba/smb.conf

... # -> On the end of the file!
[shared]
 comment = Shared directory for user
 browseable = no
 path = /home/user/shared
 read only = no
 writeable = yes
 create mask = 0700
 directory mask = 0700
 valid users = user
 
 
smbpasswd -a user
systemctl restart smbd
```

```powershell title="smb - client"
apt insall cifs-utils gvfs-backend
# File explorer -> smb://smb.zalduabat.eus/shared



nano /etc/network/interfaces

auto lo
iface lo inet dhcp

auto enp0s3
iface lo inet dhcp

auto enp0s18
iface enp0s18 inet dhcp


systemctl restart networking
```

```powershell title="check folder"
smb://smb.zalduabat.eus/shared
user
WORKGROUP
passwd: ****
```
