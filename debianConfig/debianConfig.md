This folder will take notes about debian configuration commands and files.

I will have two note types:
- Service configurations (ossh, dhcp, dns, ...)
- Configuration files

Service configurations will explain what kind of configurations we have to set up in order to get that service running.
In the other hand, configuration files will gather and explain all configuration file options.
# Index - Service configurations
-  [networkInterfaces](/debianConfig/serviceConfigurations/networkInterfaces.md) (not a service though)
- [openssh](/debianConfig/serviceConfigurations/openssh.md)
- [dhcp](/debianConfig/serviceConfigurations/dhcp.md)
- [dns](/debianConfig/serviceConfigurations/dns.md)

# Index - Configuration files
- /etc
	- /network
		- /[interfaces](/debianConfig/configurationFiles/etc/network/interfaces.md)
	- /[hostname](/debianConfig/configurationFiles/etc/hostname.md)
	- /default
		- /[isc-dhcp-server](/debianConfig/configurationFiles/etc/default/isc-dhcp-server.md)
	- /dhcp
		- /[dhcpd.conf](/debianConfig/configurationFiles/etc/dhcp/dhcpd.conf.md)
	- /bind
		- /[named.conf.options](/debianConfig/configurationFiles/etc/bind/named.conf.options.md)
		- /[named.conf.local](/debianConfig/configurationFiles/etc/bind/named.conf.local.md)

/etc/bind/named.conf.local