```powershell title="default dhcpd.conf conf"
# dhcpd.conf
#
# Sample configuration file for ISC dhcpd
#

# option definitions common to all supported networks...
#option domain-name "example.org";
#option domain-name-servers ns1.example.org, ns2.example.org;

default-lease-time 600;
max-lease-time 7200;

# The ddns-updates-style parameter controls whether or not the server will
# attempt to do a DNS update when a lease is confirmed. We default to the
# behavior of the version 2 packages ('none', since DHCP v2 didn't
# have support for DDNS.)
ddns-update-style none;

# If this DHCP server is the official DHCP server for the local
# network, the authoritative directive should be uncommented.
authoritative;

# Use this to send dhcp log messages to a different log file (you also
# have to hack syslog.conf to complete the redirection).
#log-facility local7;

# No service will be given on this subnet, but declaring it helps the
# DHCP server to understand the network topology.

#subnet 10.152.187.0 netmask 255.255.255.0 {
#}

# This is a very basic subnet declaration.

#subnet 10.254.239.0 netmask 255.255.255.224 {
#  range 10.254.239.10 10.254.239.20;
#  option routers rtr-239-0-1.example.org, rtr-239-0-2.example.org;
#}

# This declaration allows BOOTP clients to get dynamic addresses,
# which we don't really recommend.

#subnet 10.254.239.32 netmask 255.255.255.224 {
#  range dynamic-bootp 10.254.239.40 10.254.239.60;
#  option broadcast-address 10.254.239.31;
#  option routers rtr-239-32-1.example.org;
#}

# A slightly different configuration for an internal subnet.
# Sample configuration for a subnet:
# subnet 10.254.239.32 netmask 255.255.255.224 {
#   range dynamic-bootp 10.254.239.40 10.254.239.60;
#   option broadcast-address 10.254.239.31;
#   option routers rtr-239-32-1.example.org;
# }

# Hosts which require special configuration options can be listed in
# host statements.   If no address is specified, the address will be
# allocated dynamically (if possible), but the host-specific information
# will still come from the host declaration.

#host passacaglia {
#  hardware ethernet 0:0:c0:5d:bd:95;
#  filename "vmunix.passacaglia";
#  server-name "toccata.example.com";
#}

# Fixed IP addresses can also be specified for hosts.   These addresses
# should not also be listed as being available for dynamic assignment.
# Hosts for which fixed IP addresses have been specified can boot using
# BOOTP or DHCP.   Hosts for which no fixed address is specified can only
# be booted with DHCP, unless there is an address range on the subnet
# to which a BOOTP client is connected which has the dynamic-bootp flag
# set.
#host fantasia {
#  hardware ethernet 08:00:07:26:c0:a5;
#  fixed-address fantasia.example.com;
#}

# You can declare a class of clients and then do address allocation
# based on that.   The example below shows a case where all clients
# in a certain class get addresses on the 10.17.224/24 subnet, and all
# other clients get addresses on the 10.0.29/24 subnet.

#class "foo" {
#  match if substring (option vendor-class-identifier, 0, 4) = "SUNW";
#}

#shared-network 224-29 {
#  subnet 10.17.224.0 netmask 255.255.255.0 {
#    option routers rtr-224.example.org;
#  }
#  subnet 10.0.29.0 netmask 255.255.255.0 {
#    option routers rtr-29.example.org;
#  }
#  pool {
#    allow members of "foo";
#    range 10.17.224.10 10.17.224.250;
#  }
#  pool {
#    deny members of "foo";
#    range 10.0.29.10 10.0.29.230;
#  }
#}
```

# Global Options

```powershell
# option definitions common to all supported networks... 
# option domain-name "example.org"; 
# option domain-name-servers ns1.example.org, ns2.example.org;  
default-lease-time 600; 
max-lease-time 7200;
```

- `option domain-name` → sets the default DNS domain for clients.
- `option domain-name-servers` → sets the default DNS servers for all clients.    
- `default-lease-time` → default time in seconds a client can keep a dynamically assigned IP if the server doesn’t specify a lease. (`600` → 10 minutes)
- `max-lease-time` → maximum allowed lease in seconds (`7200` → 2 hours).

---

```powershell
# The ddns-updates-style parameter controls whether or not the server will 
# attempt to do a DNS update when a lease is confirmed. 
ddns-update-style none;
```

- Controls **Dynamic DNS updates**.
- `none` → don’t try to update DNS automatically.
- Alternatives: `interim` for standard DDNS, `ad-hoc` for advanced setups.

---

```powershell
# If this DHCP server is the official DHCP server for the local 
# network, the authoritative directive should be uncommented. 
authoritative;
```

- **Important!**
- Tells clients: “I am the **official DHCP server** for this network.”
- If a client has an IP from a previous lease (or a rogue server), an authoritative DHCP server will send a **DHCPNAK** to force the client to request a correct IP.

---

```powershell
# Use this to send dhcp log messages to a different log file 
log-facility local7;
```

- Optional: redirect DHCP logs to another syslog facility.
- By default, logs go to `/var/log/syslog`.

---

# Subnet Declarations

### Example “empty subnet”:

```powershell
# No service will be given on this subnet, but declaring it helps the 
# DHCP server to understand the network topology. 
subnet 10.152.187.0 netmask 255.255.255.0 {
}
```

- Tells the server: “This subnet exists, but I won’t give IPs here.”
- Useful for **network topology awareness** and **routing**, e.g., when multiple subnets are on the same physical network.

---

### Example basic subnet:

```powershell
subnet 10.254.239.0 netmask 255.255.255.224 { 
  range 10.254.239.10 10.254.239.20; 
  option routers rtr-239-0-1.example.org, rtr-239-0-2.example.org; 
}
```

- `subnet ... netmask ...` → defines a DHCP-served subnet.
- `range ...` → the pool of IPs the server can give dynamically.
- `option routers` → default gateway for clients in this subnet.

---

### Dynamic BOOTP example:

```powershell
subnet 10.254.239.32 netmask 255.255.255.224 { 
  range dynamic-bootp 10.254.239.40 10.254.239.60; 
  option broadcast-address 10.254.239.31; 
  option routers rtr-239-32-1.example.org; 
}
```

- `dynamic-bootp` → allows old BOOTP clients to request IPs dynamically.
- `option broadcast-address` → broadcast IP for the subnet.
- BOOTP is **legacy**, usually replaced by DHCP.
- BOOTP: Old protocol from the 1980s used to assign IP addresses to diskless clients **when they booted**.

---

# Host Declarations

```powershell
host passacaglia { 
  hardware ethernet 0:0:c0:5d:bd:95; 
  filename "vmunix.passacaglia"; 
  server-name "toccata.example.com"; 
}
```

- Assigns **specific options to a single host** (based on MAC).
- Example: you can boot a host via PXE with a specific kernel or filename.

```powershell
host zaldua1bez1 { 
  hardware ethernet 08:00:07:26:c0:a5; 
  fixed-address 192.168.44.23;
}
```

- Gives a **fixed IP** to a client with a specific MAC.
- Useful for servers or devices that need a permanent IP.

---
# DHCP Failover

```powershell
# Allows two DHCP servers (primary and secondary) to share IP management 
# to provide high availability and service continuity. 
# One acts as the primary (authoritative), the other as secondary (backup).  
failover peer "zaldua-dhcp-failover" {
  primary;                     # This server is the primary
  address 192.168.42.4;        # IP of the primary server
  port 647;                    # Port used for failover
  peer address 192.168.44.5;   # IP of the secondary server
  peer port 847;               # Port used by the secondary
  max-response-delay 60;       # Maximum response delay between peers
  max-unacked-updates 10;      # Maximum number of unacknowledged updates
  mclt 3600;                   # Maximum Client Lead Time (in seconds)
  split 128;                   # Number of leases assigned to primary vs secondary
}
```

- **primary** → main server, authoritative, responds first to clients
- **secondary** → backup server, only acts if primary fails
- **max-response-delay** → how long a server waits before resending info
- **max-unacked-updates** → max number of pending updates between peers
- **mclt** → extra time a server can give a client before confirming
- **split** → how IPs are divided between primary and secondary (default 128/128)

---
### Apply to subnets without pool

```powershell
# Subnet 1 
subnet 192.168.42.0 netmask 255.255.254.0 {
  range 192.168.42.100 192.168.42.200;
  option routers 192.168.42.1;
  option domain-name-servers 192.168.42.4, 192.168.44.5;
  option domain-name "zalduabat.eus";
  default-lease-time 600;
  max-lease-time 720;
  failover peer "zaldua-dhcp-failover";    # <- Failover applied here 
}  

# Subnet 2 
subnet 192.168.44.0 netmask 255.255.254.0 {
  range 192.168.44.100 192.168.44.200;
  option routers 192.168.44.2;
  option domain-name-servers 192.168.42.4, 192.168.44.5;
  option domain-name "zalduabat.eus";
  default-lease-time 600;
  max-lease-time 720;
  failover peer "zaldua-dhcp-failover";    # <- Also applied here 
}
```

### Apply to subnets with pool

```powershell
# Subnet 1 with pool
subnet 192.168.42.0 netmask 255.255.254.0 {
  pool {
    range 192.168.42.100 192.168.42.200;
    failover peer "zaldua-dhcp-failover";    # <- Failover applied only to this pool
  }
  option routers 192.168.42.1;
  option domain-name-servers 192.168.42.4, 192.168.44.5;
  option domain-name "zalduabat.eus";
  option broadcast-address 192.168.43.255;
  default-lease-time 600;
  max-lease-time 720;
}

# Subnet 2 with pool
subnet 192.168.44.0 netmask 255.255.254.0 {
  pool {
    range 192.168.44.100 192.168.44.200;
    failover peer "zaldua-dhcp-failover";    # <- Only this pool participates in failover
  }
  option routers 192.168.44.2;
  option domain-name-servers 192.168.42.4, 192.168.44.5;
  option domain-name "zalduabat.eus";
  option broadcast-address 192.168.45.255;
  default-lease-time 600;
  max-lease-time 720;
}
```

---
# Classes

```powershell
class "foo" { 
  match if substring (option vendor-class-identifier, 0, 4) = "SUNW"; 
}
```

- Defines a **class of clients** based on options (like vendor).
- You can allocate IPs differently depending on class (e.g., Sun machines vs others).

---

# Shared Network Example

```powershell
shared-network 224-29 { 
  subnet 10.17.224.0 netmask 255.255.255.0 { ... } 
  subnet 10.0.29.0 netmask 255.255.255.0 { ... } 
  pool { allow members of "foo"; range 10.17.224.10 10.17.224.250; } 
  pool { deny members of "foo"; range 10.0.29.10 10.0.29.230; } 
}
```

- Allows **multiple subnets on the same physical network** (layer 2).
- Pools can **include or exclude classes**.
- Useful for **complex lab setups** or large campuses.

---

## 🔹 Summary / Key Concepts

1. **Global options** → default lease times, DNS, DDNS style, authoritative.
2. **Subnet blocks** → define which IPs the server can hand out and network options.
3. **Host declarations** → special options or fixed IPs for individual machines.
4. **Classes** → group clients for special allocation rules.
5. **Shared networks** → handle multiple subnets on one broadcast domain.
6. **Legacy support** → `dynamic-bootp` and PXE options for old clients.