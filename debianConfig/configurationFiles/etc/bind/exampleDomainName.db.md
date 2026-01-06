```powershell title="Basic configuration"
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

### 🔹 `@` (zone origin)

```
@
```

- Represents the **zone name itself**
- For `zalduabat.eus`, `@` = `zalduabat.eus.`

---

```powershell
@ IN SOA serv1.zalduabat.eus. admin.zalduabat.eus. (
    1
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

