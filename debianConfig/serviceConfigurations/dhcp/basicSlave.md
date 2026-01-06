- **zalduabat (192.168.42.0/23)**  
    → `42.168.192.in-addr.arpa`  
    → `43.168.192.in-addr.arpa`
    
- **zalduabi (192.168.44.0/23)**  
    → `44.168.192.in-addr.arpa`  
    → `45.168.192.in-addr.arpa`

```powershell title="creating cache for bind"
mkdir -p /var/cache/bind
chown -R bind:bind /var/cache/bind
chmod 750 /var/cache/bind
```

> Important
> We are creating this file for the secondary server to copy the zones from the primary

```powershell title="slave - /etc/bind/named.conf.options"
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

```powershell title="slave - /etc/bind/named.conf.local"
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

> Important
> We don't need to configure direct or reverse zone files in the secondary

## ✅ Check zone transfer (quick)

**1. Check if the slave receives the zone**

```powershell
journalctl -u bind9 -f
```

You should see:

```
Transfer started Transfer completed
```

**2. Check if zone files were created**

```powershell
ls /var/cache/bind/
```

**3. Query the slave**

```powershell
dig @192.168.44.5 client1.zalduabat.eus
dig @192.168.44.5 -x 192.168.42.101
```

**4. Test AXFR from the slave**

```powershell
dig +tcp @192.168.44.4 zalduabat.eus AXFR
```

**5. Force refresh (optional)**

```powershell
rndc refresh zalduabat.eus
```