## Common DNS Test Commands

### `dig`

- Basic tool to query DNS servers.
- Syntax: `dig @<server> <name> <type>`
    - `@server` → which DNS server to query
    - `<name>` → domain or hostname
    - `<type>` → record type (`A`, `PTR`, `NS`, `AXFR`, etc.)
- Example: `dig @192.168.44.5 serv1.zalduabat.eus A`

---

### `nslookup`

- Another DNS query tool, simpler than dig.
- Syntax: `nslookup <name> <server>`
- Example: `nslookup serv1.zalduabat.eus 127.0.0.1`
- Returns the IP address of a domain.

---

## Test Forward (A) Resolution

Checks that the DNS server returns the correct IP for a hostname.

```powershell
dig @localhost serv1.zalduabat.eus 
dig @localhost client2.zalduabi.eus
```

Or using `nslookup`:

`nslookup serv1.zalduabat.eus 127.0.0.1`

✅ Expected: Server returns the correct IPv4 addresses.

---

## Test Reverse (PTR) Resolution

Checks that the server can resolve an IP to a hostname.

```powershell
dig -x 192.168.42.4 @localhost 
dig -x 192.168.44.5 @localhost
```

- `-x` → reverse lookup (IP → hostname)  
    ✅ Expected: returns hostnames:

`serv1.zalduabat.eus. serv2.zalduabi.eus.`

---

## Master/Slave Setup Tests

### 1️⃣ Check Zone Transfer (AXFR)

Use from the **master** or a machine that should pull zones from the slave.

```powershell
dig @192.168.44.5 zalduabat.eus AXFR 
dig @192.168.44.5 zalduabi.eus AXFR 
dig @192.168.44.5 42.168.192.in-addr.arpa AXFR 
dig @192.168.44.5 44.168.192.in-addr.arpa AXFR
```

- `AXFR` → full zone transfer
- `@192.168.44.5` → points to the **slave**
- Use this to verify the slave has copied the zones.

✅ If the slave responds with all zone entries, the transfer works.

> Note: AXFR **from the slave to other machines usually fails** — slaves do not serve full zone transfers by default.

---

### 2️⃣ Query Specific Records on the Slave

Check that the slave responds with the same data as the master.

```powershell
dig @192.168.44.5 serv2.zalduabi.eus 
dig @192.168.44.5 -x 4.42.168.192.in-addr.arpa
```

- Should return the **same results as the master**.
- If `NXDOMAIN` or no response → zone not transferred or server unreachable.

---

### ✅ Summary

- Use **dig or nslookup** for simple forward/reverse checks.
- Use **AXFR** only to test zone replication from master → slave.
- Always check that slave answers match the master for normal queries.