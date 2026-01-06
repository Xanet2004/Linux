DHCP Automatically assigns IP addresses and network settings to devices on a network.
# Index
- [Primary](/debianConfig/serviceConfigurations/dhcp/basicPrimary.md)
- [Secondary](/debianConfig/serviceConfigurations/dhcp/basicSecondary.md)

# File index
- [/etc/default/isc-dhcp-server](/debianConfig/configurationFiles/etc/default/isc-dhcp-server.md) – Specifies interfaces to serve
- [/etc/dhcp/dhcpd.conf](/debianConfig/configurationFiles/etc/dhcp/dhcpd.conf.md) – Main DHCP configuration file
- [/etc/dhcpcd.conf](/debianConfig/configurationFiles/etc/dhcpcd.conf.md) - Change DNS on this file after configuring a DNS server IF **this is a DHCP server**.

# Installation

```powershell title="installation"
apt update
apt-get install isc-dhcp-server
```
# Basic configuration example

```powershell title="/etc/default/isc-dhcp-server"
INTERFACESv4="enp0s18"  # This will be the interface that DHCP will look
INTERFACESv6=""
```

```powershell title="/etc/dhcp/dhcpd.conf"
# option domain-name "zalduabat.eus";
# option domain-name-servers 192.168.42.2, 192.168.44.4;

authoritative;  # IMPORTANT TO USE THIS ONLY ON THE PRIMARY SERVER

# Subnet 1: 192.168.42.0/23
subnet 192.168.42.0 netmask 255.255.254.0 {
    range 192.168.42.100 192.168.42.200;
    option domain-name-servers 192.168.42.4, 192.168.44.5;
    option domain-name "zalduabat.eus";
    option routers 192.168.42.2;
    option broadcast-address 192.168.43.255;
    default-lease-time 60;
    max-lease-time 720;
}

# Subnet 2: 192.168.44.0/23
subnet 192.168.44.0 netmask 255.255.254.0 {
    range 192.168.44.100 192.168.44.200;
	option domain-name-servers 192.168.42.4, 192.168.44.5;
    option domain-name "zalduabat.eus";
    option routers 192.168.44.2;
    option broadcast-address 192.168.45.255;
	default-lease-time 60;
    max-lease-time 720;
}
```

> Important!
> If there is a second DHCP server in Subnet 2, we MUST remove or comment the subnet 2 from the first server.