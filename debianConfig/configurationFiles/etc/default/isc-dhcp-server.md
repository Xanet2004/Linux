```powershell title="default isc-dhcp-server conf"
# Defaults for isc-dhcp-server (sourced by /etc/init.d/isc-dhcp-server)

# Path to dhcpd's config file (default: /etc/dhcp/dhcpd.conf).
#DHCPDv4_CONF=/etc/dhcp/dhcpd.conf
#DHCPDv6_CONF=/etc/dhcp/dhcpd6.conf

# Path to dhcpd's PID file (default: /var/run/dhcpd.pid).
#DHCPDv4_PID=/var/run/dhcpd.pid
#DHCPDv6_PID=/var/run/dhcpd6.pid

# Additional options to start dhcpd with.
#       Don't use options -cf or -pf here; use DHCPD_CONF/ DHCPD_PID instead
#OPTIONS=""

# On what interfaces should the DHCP server (dhcpd) serve DHCP requests?
#       Separate multiple interfaces with spaces, e.g. "eth0 eth1".
INTERFACESv4=""
INTERFACESv6=""
```

- `INTERFACESv4` → Defines which interfaces the DHCPv4 server will listen on.  
  - If left empty, **dhcpd will not listen on any interface**.  
  - Example: `INTERFACESv4="enp0s18"` for the internal LAN interface.

- `INTERFACESv6` → Same as above, but for IPv6.

- `OPTIONS` → Additional parameters for starting dhcpd.  
  - **Do not use `-cf` or `-pf` here**, those are handled by `DHCPDv4_CONF` and `DHCPDv4_PID`.

- `DHCPDv4_CONF` → Default: `/etc/dhcp/dhcpd.conf`, where subnets, ranges, and options are defined.

- `DHCPDv4_PID` → PID file, useful for debugging or restarting the service.

> ⚠️ Common errors:
> - Using NAT interface (`enp0s3`) instead of the LAN interface (`enp0s18`) causes the server **not to respond to DHCP requests**, even if dhcpd starts without errors.
> - Always use the interface connected to the network where you want to assign IPs.
> - If you see messages like: `Not configured to listen on any interfaces!` → usually `INTERFACESv4` is empty or points to the wrong interface.
