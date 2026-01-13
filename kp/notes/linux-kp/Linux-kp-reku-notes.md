
```powershell title="machines"
# udala
udala
172.18.4.4/22  - 00:01:01:01:01:03
192.168.2.4/25 - 00:01:01:01:02:03

# liburutegia
liburutegia
172.18.4.5/22  - 00:01:01:01:01:02

# musakola
musakola # -> udaletxea
192.168.2.5/25 - 00:01:01:01:02:02
```

```powershell title="networks"
# Udaletxea
udaletxea
172.18.4.0/22
255.255.252.0
172.18.4.0
172.18.5.0
172.18.6.0

# Kiroldegia
kiroldegia
192.168.2.0/25
255.255.255.128
```

```powershell title="port forwardings"
#shhudal
2271 guestIP 22

#shhlibu
2277 guestIP 22

#shhkiro
2279 guestIP 22
```

```powershell title="ssh"
#shhudal - udala
ssh -p 2271 zalduax@localhost

#shhlibu - liburutegia
ssh -p 2277 zalduax@localhost

#shhkiro - musakola
ssh -p 2279 zalduax@localhost
```

# 1.1 udala machine

```powershell title="udala"
# MACHINE CONF
# udala
VBoxManage createvm --name "udala" --ostype "Debian_64" --register --basefolder "C:\Users\xanet\VirtualBox VMs" --groups "/Irakaskuntza/2025-2026/Azpiegiturak eta Sistemak/kp2"

# Basic conf
VBoxManage modifyvm "udala" --memory 2048 --cpus 1 --vram 20 --rtc-use-utc on --graphicscontroller vmsvga --firmware bios --mouse usbtablet --audio-enabled off

# NICs
#VBoxManage modifyvm "udala" --nic2 nat --mac-address2 000102030101
VBoxManage modifyvm "udala" --nic1 none
VBoxManage modifyvm "udala" --nic2 intnet --mac-address2 000101010103 --intnet2 "udaletxea"
vboxmanage modifyvm "udala" --nic6 intnet --mac-address6 000101010203 --intnet6 "kiroldegia"
vboxmanage modifyvm "udala" --nic7 nat

# ISO controller
#VBoxManage storagectl "udala" --name "IDE" --add ide --controller PIIX4

# HDD controller
VBoxManage storagectl "udala" --name "SATAkont1" --add sata --controller IntelAhci --portcount 2

# ISO attach
#VBoxManage storageattach "udala" --storagectl "IDE" --port 0 --device 0 --type dvddrive --medium "C:\Users\xanet\SynologyDrive\Study\Mondragon\3. urtea\AzpiegiturakEtaSistemak\ISO\debian-13.2.0-amd64-netinst.iso"

# Create medium
#VBoxManage createmedium disk --filename "C:\Users\xanet\VirtualBox VMs\Linux\xanet-zaldua\Irakaskuntza/2025-2026/Azpiegiturak eta Sistemak/kp2\udala\udala-disk" --size "120000" --format VDI
# HDD attach
VBoxManage storageattach "udala" --storagectl "SATAkont1" --port 0 --device 0 --type hdd --medium "C:\Users\xanet\VirtualBox VMs\Irakaskuntza/2025-2026/Azpiegiturak eta Sistemak/kp2/udaletxea\udala.vdi"


# PORT REDIRECTION
VBoxManage modifyvm "udala" --natpf7 "sshudal,tcp,,2271,,22"


# SNAPSHOT
VBoxManage snapshot "udala" take "00_beforeInitialisation" --description="This is the virtual machine before starting it for the first time."


# RUN
VBoxManage startvm "udala"
```

deluser user --remove-home

# Clones

```powershell
VBoxManage clonevm "udala" --basefolder "C:\Users\xanet\VirtualBox VMs" --groups "/Irakaskuntza/2025-2026/Azpiegiturak eta Sistemak/kp2" --mode machine --name "liburutegia" --snapshot "zalduax" --register

VBoxManage clonevm "udala" --basefolder "C:\Users\xanet\VirtualBox VMs" --groups "/Irakaskuntza/2025-2026/Azpiegiturak eta Sistemak/kp2" --mode machine --name "musakola" --snapshot "zalduax" --register
```

```powershell title="configure liburutegia"
# liburutegia
VBoxManage modifyvm "liburutegia" --nic1 none --nic2 none --nic6 none --nic7 none --nic8 none
VBoxManage modifyvm "liburutegia" --nic7 intnet --mac-address7 000101010102 --intnet7 udaletxea
VBoxManage modifyvm "liburutegia" --nic8 nat --natpf8 "sshlibu,tcp,,2277,,22"
```

```powershell title="configure musakola"
# musakola
VBoxManage modifyvm "musakola" --nic1 none --nic2 none --nic6 none --nic7 none --nic8 none
VBoxManage modifyvm "musakola" --natpf7 delete sshudal
VBoxManage modifyvm "musakola" --nic7 nat --natpf7 "sshkiro,tcp,,2279,,22"
VBoxManage modifyvm "musakola" --nic8 intnet --mac-address8 000101010202 --intnet8 kiroldegia
```

```powershell
VBoxManage snapshot "liburutegia" take "01_cloneConfig" --description="This is the cloned virtual machine after configurations."
VBoxManage snapshot "musakola" take "01_cloneConfig" --description="This is the cloned virtual machine after configurations."
```

```powershell title="udala - /etc/bind/named.conf.root-hints"
  GNU nano 8.4           /etc/bind/named.conf.root-hints
// prime the server with knowledge of the root servers

acl everyone { any; };

view everyone {
   match-clients { everyone; };
   zone "." {
      type hint;
      file "/usr/share/dns/root.hints";
   };
}
```

```powershell title="udala - named.conf.options"
options {
	directory "/var/cache/bind";

	listen-on { localhost; 172.18.4.0; 192.168.2.0; };
	listen-on-v6 { none; };

	recursion no;

	allow-query { localhost; 172.18.4.0; 192.168.2.0; };

	forward first;

	forwarders {
		10.2.10.1;
	};

	dnssec-validation auto;
};
```

```powershell title="others - named.conf.options"
options {
	directory "/var/cache/bind";

	listen-on { localhost; 172.18.4.0; 192.168.2.0; };
	listen-on-v6 { none; };

	recursion yes;

	allow-recursion {
        localhost;
    };

	allow-query { localhost; 172.18.4.0; 192.168.2.0; };

	forward first;

	forwarders {
		10.2.10.1;
	};

	dnssec-validation auto;
};
```

```powershell title="udala - named.conf.local"
acl acl-udaletxea { localhost; 172.18.4.0/22; };
acl acl-kiroldegia { localhost; 192.168.2.0/25; };

view bista-udaletxea {
   match-clients { acl-udaletxea; };

   zone "arrasate.eus" {
      type master;
      file "/etc/bind/arrasate.eus.db.bista-udaletxea";
      allow-transfer { localhost; };
   };
};

view bista-kiroldegia {
   match-clients { acl-kiroldegia; };

   zone "arrasate.eus" {
      type master;
      file "/etc/bind/arrasate.db.bista-kiroldegia";
      allow-transfer { localhost; };
   };
};
```

```powershell title="liburutegia - named.conf.local"
zone "arrasate.eus" {
    type slave;
    file "/etc/bind/arrasate.db.bista-liburutegia";
    masters { 192.168.2.4; };
};
```

```powershell title="musakola - named.conf.local"
zone "arrasate.eus" {
    type slave;
    file "/etc/bind/arrasate.db.bista-udaletxea";
    masters { 192.168.2.4; };
};
```

```powershell title="/etc/bind/arrasate.db.bista-udaletxea"
$TTL 86400
@   IN  SOA udala.arrasate.eus. (
        1
        604800
        86400
        2419200
        86400 )

@       IN  NS  udala.arrasate.eus.
@       IN  NS  musakola.arrasate.eus.

udala        IN  A     192.168.2.4
musakola     IN  A     192.168.2.5
www          IN  CNAME udala.arrasate.eus.
```
```powershell title="/etc/bind/arrasate.db.bista-liburutegia"
$TTL 86400
@   IN  SOA udala.arrasate.eus. (
        1
        604800
        86400
        2419200
        86400 )

@       IN  NS  udala.arrasate.eus.
@       IN  NS  liburutegia.arrasate.eus.

udala        IN  A     172.18.4.4
liburutegia  IN  A     172.18.4.5
www          IN  CNAME udala.arrasate.eus.
```

```powershell title="/etc/bind/db.192.168.2"
$TTL 86400
@   IN  SOA udala.arrasate.eus. (
        1
        604800
        86400
        2419200
        86400 )

@       IN  NS  udala.arrasate.eus.
@       IN  NS  musakola.arrasate.eus.

4       IN  PTR   udala.arrasate.eus.
5       IN  PTR   musakola.arrasate.eus.
```

```powershell title="/etc/bind/db.172.18.4"
$TTL 86400
@   IN  SOA udala.arrasate.eus. (
        1
        604800
        86400
        2419200
        86400 )

@       IN  NS  udala.arrasate.eus.
@       IN  NS  liburutegia.arrasate.eus.

4       IN  PTR   udala.arrasate.eus.
5       IN  PTR   liburutegia.arrasate.eus.
```
```powershell title="/etc/bind/db.172.18.5"
$TTL 86400
@   IN  SOA udala.arrasate.eus. (
        1
        604800
        86400
        2419200
        86400 )

@       IN  NS  udala.arrasate.eus.
@       IN  NS  liburutegia.arrasate.eus.
```
```powershell title="/etc/bind/db.172.18.6"
$TTL 86400
@   IN  SOA udala.arrasate.eus. (
        1
        604800
        86400
        2419200
        86400 )

@       IN  NS  udala.arrasate.eus.
@       IN  NS  liburutegia.arrasate.eus.
```











```powershell title="example"

```