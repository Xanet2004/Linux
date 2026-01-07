
# File index

- /etc/default/isc-dhcp-server – Specifies interfaces to serve
- /etc/dhcp/dhcpd.conf – Main DHCP configuration file    

# Basic configuration

```powershell title="/etc/default/isc-dhcp-server"
INTERFACESv4="enp0s18 enp0s19"  # This will be the interface that DHCP will look
INTERFACESv6=""
```

```powershell title="/etc/dhcp/dhcpd.conf"
option domain-name "zalduabat.eus";
option domain-name-servers 192.168.42.2, 192.168.44.4;

authoritative; # IMPORTANT TO USE THIS ONLY ON THE PRIMARY SERVER

default-lease-time 600;
max-lease-time 7200;

failover peer "dhcp-failover" {
    primary;                    # this is the primary
    address 192.168.44.4;       # primary server IP
    port 647;                   # default failover port
    peer address 192.168.44.5;  # secondary server IP
    peer port 647;
    max-response-delay 60;
    max-unacked-updates 10;
    mclt 1800;                  # maximum client lead time
    split 128;                  # how to split IP pool (128 = 50/50)
}

# Subnet 1: 192.168.42.0/23
subnet 192.168.42.0 netmask 255.255.254.0 {
    range 192.168.42.100 192.168.42.200;
    option routers 192.168.42.2;
    option broadcast-address 192.168.43.255;
    failover peer "dhcp-failover";
}

# Subnet 2: 192.168.44.0/23
subnet 192.168.44.0 netmask 255.255.254.0 {
    range 192.168.44.100 192.168.44.200;
    option routers 192.168.44.2;
    option broadcast-address 192.168.45.255;
    failover peer "dhcp-failover";
}
```