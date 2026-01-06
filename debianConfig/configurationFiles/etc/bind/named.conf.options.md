This file defines **global DNS server behaviour**.

```powershell title="default dhcpd.conf conf"
options {
	directory "/var/cache/bind";
};
```
- `directory` → where BIND stores cache and runtime files
---
## Common options you can add

### 1. `listen-on`

Defines **IPv4 addresses** where DNS will listen.

`listen-on { 127.0.0.1; 192.168.44.4; };`

- Useful to restrict DNS to specific interfaces
- `any;` allows all IPv4 interfaces

---

### 2. `listen-on-v6`

Defines **IPv6 addresses**.

`listen-on-v6 { none; };`

- Disable IPv6 DNS if not used
- Avoids confusion in lab environments

---

### 3. `recursion`

Controls whether the server performs recursive queries.

`recursion yes;`

- `yes` → the server resolves queries on behalf of clients (asks other DNS servers if needed)
- `no` → the server only answers for its own zones and does not query other DNS servers

---

### 4. `allow-recursion`

Restricts **who can use recursion**.

`allow-recursion { localhost; 192.168.44.0/23; };`

- Prevents open resolver (security)
- Often combined with `recursion yes`

---

### 5. `allow-query`

Controls **who can query the DNS server**.

`allow-query { any; };`

- `any` → public DNS
- Restrict to local networks for internal DNS

---

### 6. `forwarders`

Defines external DNS servers to forward queries to.

`forwarders {     8.8.8.8;     1.1.1.1; };`

- Used when DNS cannot resolve locally
- Common in enterprise networks

---

### 7. `forward`

Defines how forwarding behaves.

`forward only;`

or

`forward first;`

- `only` → always forward
- `first` → try root servers, then forward

---

### 8. `dnssec-validation`

Enables or disables DNSSEC validation.

`dnssec-validation auto;`

- `auto` → recommended default
- `no` → disable (useful for labs)

---

### 9. `auth-nxdomain`

RFC compliance for NXDOMAIN responses.

`auth-nxdomain no;`

- Mostly legacy compatibility
- Often left unchanged

---

### 10. `querylog`

Enable query logging.

`querylog yes;`

- Useful for debugging
- Not recommended in production (performance)

---

### 11. `allow-transfer`

Controls **zone transfers** (AXFR).

`allow-transfer { 192.168.44.5; };`

- Critical for **primary → secondary DNS**
- Should NEVER be `any;`

---

### 12. `notify`

Notifies secondary servers of zone changes.

`notify yes;`

- Required for DNS primary/secondary setups

---

## Example: Typical lab configuration

```powershell
options {
	directory "/var/cache/bind"; # Directory where BIND stores cache and runtime files
    
    listen-on { any; }; # Listen for DNS queries on all IPv4 interfaces
    listen-on-v6 { none; }; # Disable DNS over IPv6
    
    recursion yes; # Allow recursive DNS queries (resolve external domains)
    
    allow-recursion { # Define which clients can use recursion
        localhost; # Allow recursion from the local machine
        192.168.44.0/23; # Allow recursion from the local network
    };
    
    allow-query { any; }; # Allow DNS queries from any client
    
    forwarders { # External DNS servers to forward unresolved queries to
        8.8.8.8; # Google DNS
        1.1.1.1; # Cloudflare DNS
    };
    
    dnssec-validation auto; # Enable DNSSEC validation automatically
};
```