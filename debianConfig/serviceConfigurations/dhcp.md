DHCP Automatically assigns IP addresses and network settings to devices on a network.
# Index
- [Primary](debianConfig/serviceConfigurations/dhcp/basicPrimary.md)
- [Secondary](debianConfig/serviceConfigurations/dhcp/basicSecondary.md)

# File index

- /etc/default/isc-dhcp-server – Specifies interfaces to serve
- /etc/dhcp/dhcpd.conf – Main DHCP configuration file    

# Installation

```powershell title="installation"
apt update
apt-get install isc-dhcp-server
```
# Basic configuration

```powershell title="/etc/default/isc-dhcp-server"
INTERFACESv4="enp0s3"  # replace with your network interface
INTERFACESv6=""
```

```powershell title="/etc/dhcp/dhcpd.conf"
option domain-name "zaldua.eus";
option domain-name-servers 192.168.42.2, 192.168.44.4;

default-lease-time 600;
max-lease-time 7200;

# Subnet 1: 192.168.42.0/23
subnet 192.168.42.0 netmask 255.255.254.0 {
    range 192.168.42.100 192.168.42.200;
    option routers 192.168.42.2;
    option broadcast-address 192.168.43.255;
}

# Subnet 2: 192.168.44.0/23
subnet 192.168.44.0 netmask 255.255.254.0 {
    range 192.168.44.100 192.168.44.200;
    option routers 192.168.44.2;
    option broadcast-address 192.168.45.255;
}
```