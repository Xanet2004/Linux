```powershell title="Basic configuration"
$TTL 86400
@   IN  SOA serv1.zalduabat.eus. admin.zalduabat.eus. (
        1  # *Serial number* (must increase on every change)
        604800
        86400
        2419200
        86400 )

@       IN  NS  serv1.zalduabat.eus.

serv1   IN  A   192.168.42.4
client1 IN  A   192.168.42.101
```

### 🔹 `@` (zone origin)

```
@
```

- Represents the **zone name itself**
- For `zalduabat.eus`, `@` = `zalduabat.eus.`

---

```powershell
@ IN SOA serv1.zalduabat.eus. admin.zalduabat.eus. (
    1  # *Serial number* (must increase on every change)
    604800
    86400
    2419200
    86400 )
```

The **most important record** in the zone.

| Field                  | Meaning                                           |
| ---------------------- | ------------------------------------------------- |
| `serv1.zalduabat.eus.` | Primary (master) DNS server                       |
| `admin.zalduabat.eus.` | Administrator email (`admin@zalduabat.eus`)       |
| `1`                    | **Serial number** (must increase on every change) |
| `604800`               | Refresh (slave checks master)                     |
| `86400`                | Retry (if refresh fails)                          |
| `2419200`              | Expire (zone becomes invalid)                     |
| `86400`                | Minimum TTL (negative cache TTL)                  |

---

### 🔹 `NS` – Name Server

```powershell
@ IN NS serv1.zalduabat.eus.
```

- Declares **authoritative DNS servers** for the zone
- Must point to **hostnames**, not IPs
- Every zone needs at least one `NS`

---

### 🔹 `A` – IPv4 address record

```powershell
serv1   IN A 192.168.42.4
client1 IN A 192.168.42.101
```

- Maps a **hostname → IPv4 address**
- `serv1.zalduabat.eus → 192.168.42.4`
- `client1.zalduabat.eus → 192.168.42.101`

---
### 🔹 Common record types (summary)

|Record|Purpose|
|---|---|
|`A`|IPv4 address|
|`AAAA`|IPv6 address|
|`NS`|Name server|
|`SOA`|Zone authority and timing|
|`MX`|Mail server|
|`CNAME`|Alias|
|`PTR`|Reverse lookup|
|`TXT`|Text / SPF / verification|

---

### 🔹 Forward vs reverse zone files

|Zone type|File contains|
|---|---|
|Forward (`zalduabat.eus`)|`A`, `AAAA`, `MX`, `CNAME`|
|Reverse (`in-addr.arpa`)|`PTR`|

---

### 🔹 Validation commands

Always validate after editing:

```powershell
named-checkconf 
named-checkzone zalduabat.eus /etc/bind/zalduabat.db
```

No output = OK.

---

### ✅ Key rules to remember

- Always increase the **SOA serial**
    
- Use **absolute names** with dots
    
- One `SOA` per zone
    
- Slaves copy `.db` files automatically
    
- Zone files are **not scripts**, order doesn’t matter

---

## 🧾 Summary

- Forward → **por dominio**
- Reverse → **por red**
- `/23` → **2 reverse**
- `/22` → **4 reverse**
- Cada `.db` tiene **1 SOA**
- Si hay reverse → usa `PTR`