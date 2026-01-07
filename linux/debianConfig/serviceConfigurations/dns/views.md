**Views** allow BIND to return **different DNS answers depending on the client IP**.

Typical use cases:

- Internal vs external DNS
- Different zones for different networks
- Split-horizon DNS
 
---
## Key rule (important)

**If you use views, ALL zones must be inside a view**  
You **cannot mix** views and global zones.

---
## Basic structure of views

Views are defined in `named.conf.local` (or included file).

Order **matters**: first matching view wins.

```powershell title="/etc/bind/named.conf.local"
view "internal" {
    match-clients { 192.168.42.0/23; 192.168.44.0/23; localhost; };

    recursion yes;

    zone "zalduabat.eus" {
        type master;
        file "/etc/bind/internal/zalduabat.db";
    };
};

view "external" {
    match-clients { any; };

    recursion no;

    zone "zalduabat.eus" {
        type master;
        file "/etc/bind/external/zalduabat.db";
    };
};
```

---

## 🔹 `match-clients`

```powershell
match-clients { 192.168.42.0/23; };
```

- Defines **who sees this view**
- Can include:
    - IPs
    - Networks
    - `localhost`
    - `any`

---

## 🔹 Recursion per view

```powershell
recursion yes;
```

- Internal → `yes`
    
- External → `no` (best practice)

---

## 🔹 Zones inside views

- Same zone name can exist in multiple views
    
- Each view uses **its own `.db` file**
    
- Files can be different or identical

Example:

```powershell
/etc/bind/internal/zalduabat.db
/etc/bind/external/zalduabat.db
```

---

## 🔁 Views with master / slave

### Master

Views contain `type master` zones

### Slave

Views contain `type slave` zones

```powershell title="7etc/bind/named.conf.local"
zone "zalduabat.eus" {
    type slave;
    file "/var/cache/bind/zalduabat.db";
    masters { 192.168.44.4; };
};
```

👉 **Views must exist on both master and slave**

---

## ⚠️ Common mistakes (exam killers)

- Defining zones **outside views**
    
- Forgetting `localhost` in internal view
    
- Using recursion in external view
    
- Same zone file for different views (wrong answers)

---

## 🧪 Quick test

`dig @server_ip zalduabat.eus dig @server_ip zalduabat.eus +trace`

Test from **different client IPs**.

---

# Example view

```powershell title="/etc/bind/named.local.conf"
//
// /etc/bind/named.conf.local
//

// View for network 192.168.42.0/24
view "net42" {
    match-clients { 192.168.42.0/24; localhost; };
    recursion yes;

    // Forward zone
    zone "zalduabat.eus" {
        type master;
        file "/etc/bind/net42/zalduabat.db";
    };

    // Reverse zone 192.168.42.0/24
    zone "42.168.192.in-addr.arpa" {
        type master;
        file "/etc/bind/net42/db.192.168.42";
    };
};

// View for network 192.168.44.0/24
view "net44" {
    match-clients { 192.168.44.0/24; };
    recursion yes;

    // Forward zone
    zone "zalduabat.eus" {
        type master;
        file "/etc/bind/net44/zalduabat.db";
    };

    // Reverse zone 192.168.44.0/24
    zone "44.168.192.in-addr.arpa" {
        type master;
        file "/etc/bind/net44/db.192.168.44";
    };
};
```

```powershell title="/etc/bind/net42/zalduabat.db"
$TTL 86400
@   IN  SOA serv1.zalduabat.eus. admin.zalduabat.eus. (
        1   ; Serial (increase on every change)
        604800 ; Refresh
        86400  ; Retry
        2419200 ; Expire
        86400  ; Minimum TTL
)
@       IN  NS  serv1.zalduabat.eus.
serv1   IN  A   192.168.42.4
client1 IN  A   192.168.42.101
```

```powershell title="/etc/bind/net44/zalduabat.db"
$TTL 86400
@   IN  SOA serv1.zalduabat.eus. admin.zalduabat.eus. (
        1   ; Serial (increase on every change)
        604800 ; Refresh
        86400  ; Retry
        2419200 ; Expire
        86400  ; Minimum TTL
)
@       IN  NS  serv1.zalduabat.eus.
serv1   IN  A   192.168.44.4
client1 IN  A   192.168.44.101
```