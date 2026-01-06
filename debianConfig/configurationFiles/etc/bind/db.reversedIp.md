## 📄 BIND9 reverse zone files (`db.reverseIp`)

Reverse zone files map **IP addresses → hostnames** using `PTR` records.  
They are used for **reverse DNS lookups** (`IP → name`).

---

## 🔁 Reverse zone naming

Reverse zones use the `in-addr.arpa` domain.

Example:

|Network|Reverse zone|
|---|---|
|`192.168.42.0/24`|`42.168.192.in-addr.arpa`|
|`192.168.43.0/24`|`43.168.192.in-addr.arpa`|

📌 **One reverse zone per /24 network**

---

## 🧱 Basic reverse zone file structure

```powershell
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

---

## 🔹 `PTR` – Pointer record (reverse lookup)

```powershell
4   IN PTR serv1.zalduabat.eus.
```

- Maps **last IP octet → hostname**
- `192.168.42.4 → serv1.zalduabat.eus`
- The **zone name already contains the network**

For:

```powershell
42.168.192.in-addr.arpa
```

Only write:

```powershell
4
101
```

---

## 🔹 How reverse resolution works

Query:

```powershell
dig -x 192.168.42.101
```

BIND:

1. Converts IP → `101.42.168.192.in-addr.arpa`
2. Finds matching reverse zone
3. Returns the `PTR` hostname

---

## 🔹 What goes into a reverse `.db`

|Record|Purpose|
|---|---|
|`SOA`|Zone authority|
|`NS`|Authoritative DNS server|
|`PTR`|IP → hostname mapping|

❌ No `A`, `CNAME`, `MX` in reverse zones

---

## 🔹 Common mistakes

- Creating **one reverse for a /23** (wrong)
    
- Using full IP instead of last octet
    
- Missing trailing dot in `PTR` target
    
- Forgetting to increase the SOA serial

---

## 🔹 Validation

```powershell
named-checkzone 42.168.192.in-addr.arpa /etc/bind/db.192.168.42
```

No output = OK.