Estructura general:

- **zalduabat (192.168.42.0/23)**
    → `42.168.192.in-addr.arpa`
    → `43.168.192.in-addr.arpa`
    
- **zalduabi (192.168.44.0/23)**
    → `44.168.192.in-addr.arpa`  
    → `45.168.192.in-addr.arpa`

```powershell title="master - /etc/bind/named.conf.options"
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

```powershell title="master - /etc/bind/named.conf.local"
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

```powershell title="master - /etc/bind/zalduabat.db"
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
```powershell title="master - /etc/bind/zalduabi.db"
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

```powershell title="master - /etc/bind/db.192.168.42"
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
```powershell title="master - /etc/bind/db.192.168.43"
$TTL 86400
@   IN  SOA serv1.zalduabat.eus. admin.zalduabat.eus. (
        1
        604800
        86400
        2419200
        86400 )

@   IN  NS  serv1.zalduabat.eus.
```

```powershell title="master - /etc/bind/db.192.168.44"
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
```powershell title="master - /etc/bind/db.192.168.45"
$TTL 86400
@   IN  SOA serv1.zalduabi.eus. admin.zalduabi.eus. (
        1
        604800
        86400
        2419200
        86400 )

@   IN  NS  serv1.zalduabi.eus.
```