DNS Translates domain names into IP addresses so devices can locate each other on the network.
# Index
- [Master](/linux/debianConfig/serviceConfigurations/dns/basicMaster.md)
- [Slave](/linux/debianConfig/serviceConfigurations/dns/basicSlave.md)
- [DHCP assigns DNS to clients]()
- [Views](/linux/debianConfig/serviceConfigurations/dns/views.md)
- [Test Commands](/linux/debianConfig/serviceConfigurations/dns/testCommands.md)

# File index
- [/etc/bind/named.conf.options](/linux/debianConfig/configurationFiles/etc/bind/named.conf.options.md) – This file defines **global DNS server behaviour**.
- [/etc/bind/named.conf.local](/linux/debianConfig/configurationFiles/etc/bind/named.conf.options.md) – This file is used to define **local DNS zones**.

> **Important**
> After configuring a DNS server, **you might need to set the DNS server as localhost**
> So change:
> 	[/etc/dhcpd.conf](/linux/debianConfig/configurationFiles/etc/dhcpcd.conf.md) if this is also a DHCP server
> 	[/etc/resolv.conf](/linux/debianConfig/configurationFiles/etc/resolv.conf.md) if this is NOT connected to a DHCP server.
# Installation

```powershell title="installation"
apt update
apt install bind9 bind9-dnsutils
```

# Basic configuration example with two networks

- **zalduabat (192.168.42.0/23)**  
    → `42.168.192.in-addr.arpa`  
    → `43.168.192.in-addr.arpa`
    
- **zalduabi (192.168.44.0/23)**  
    → `44.168.192.in-addr.arpa`  
    → `45.168.192.in-addr.arpa`

```powershell title="/etc/resolv.conf"
# If you don't have any dhcp server change this file
nameserver localhost # Master dns server
nameserver 8.8.8.8 # Secondary just in case
```

```powershell title="/etc/dhcp/dhcpd.conf"
# If you already have a dhcp server, you will need to configure the DNS on /etc/dhcp/dhcpd.conf
option domain-name "zaldua.eus";
option domain-name-servers serv1.zalduabat.eus, serv1.zalduabi.eus;
```

```powershell title="/etc/bind/named.conf.options"
options {
    directory "/var/cache/bind";

    recursion yes;
    allow-query { any; };

    listen-on { any; };
    listen-on-v6 { none; };
};
```

```powershell title="/etc/bind/named.conf.local"
// Forward zones
zone "zalduabat.eus" {
    type master;
    file "/etc/bind/zalduabat.db";
};

zone "zalduabi.eus" {
    type master;
    file "/etc/bind/zalduabi.db";
};

// Reverse zones zalduabat (192.168.42.0/23)
zone "42.168.192.in-addr.arpa" {
    type master;
    file "/etc/bind/db.192.168.42";
};

zone "43.168.192.in-addr.arpa" {
    type master;
    file "/etc/bind/db.192.168.43";
};

// Reverse zones zalduabi (192.168.44.0/23)
zone "44.168.192.in-addr.arpa" {
    type master;
    file "/etc/bind/db.192.168.44";
};

zone "45.168.192.in-addr.arpa" {
    type master;
    file "/etc/bind/db.192.168.45";
};
```

```powershell title="/etc/bind/zalduabat.db"
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
```powershell title="/etc/bind/zalduabi.db"
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

```powershell title="/etc/bind/db.192.168.42"
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
```powershell title="/etc/bind/db.192.168.43"
$TTL 86400
@   IN  SOA serv1.zalduabat.eus. admin.zalduabat.eus. (
        1
        604800
        86400
        2419200
        86400 )

@   IN  NS  serv1.zalduabat.eus.
```

```powershell title="/etc/bind/db.192.168.44"
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
```powershell title="/etc/bind/db.192.168.45"
$TTL 86400
@   IN  SOA serv1.zalduabi.eus. admin.zalduabi.eus. (
        1
        604800
        86400
        2419200
        86400 )

@   IN  NS  serv1.zalduabi.eus.
```

---
## Test forward (A) resolution

```powershell
dig @localhost serv1.zalduabat.eus 
dig @localhost client2.zalduabi.eus
```

or using `nslookup`:

```powershell
nslookup serv1.zalduabat.eus 127.0.0.1
```

✅ Expected result: the server returns the correct IPv4 addresses.

---
## Test reverse (PTR) resolution

```powershell
dig -x 192.168.42.4 @localhost 
dig -x 192.168.44.5 @localhost
```

✅ Expected result: returns the hostname for the IP:

```powershell
serv1.zalduabat.eus. serv2.zalduabi.eus.
```

# Test for Master/Slave architectures
## Check Zone Transfer (AXFR)

From the **master** (or any machine with `dig` installed):

```powershell
dig @192.168.44.5 zalduabat.eus AXFR
dig @192.168.44.5 zalduabi.eus AXFR

dig @192.168.44.5 42.168.192.in-addr.arpa AXFR
dig @192.168.44.5 44.168.192.in-addr.arpa AXFR
```

- `@192.168.44.5` → points to the **slave**    
- `AXFR` → requests a **full zone transfer**

✅ If the slave responds with all the zone entries, the transfer is working correctly.

---

## Query a Specific Record on the Slave

For example, from the master:

```powershell
dig @192.168.44.5 serv2.zalduabat.eus
dig @192.168.44.5 -x 4.42.168.192.in-addr.arpa
```

- You should get the **same response as on the master**.
- If you get **`NXDOMAIN`** or no response, there’s an issue with the zone or communication.
