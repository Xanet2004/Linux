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
- [routing](/debianConfig/serviceConfigurations/routing.md)
- [ldap](/debianConfig/serviceConfigurations/ldap.md)
- [www](/debianConfig/serviceConfigurations/www.md)
- [docker](/debianConfig/serviceConfigurations/docker.md)
- [smb](/debianConfig/serviceConfigurations/smb.md)
- [backups](/debianConfig/serviceConfigurations/backups.md) - Segurtasun kopiak
- [task automatisations](/debianConfig/serviceConfigurations/taskAutomatisations.md) - Ataza automatizazioa

# Index - Configuration files
`network interfaces - openssh`
- /etc
	- /[dhcpcd.conf](/debianConfig/configurationFiles/etc/dhcpcd.conf.md) - Change DNS on this file after configuring a DNS server IF **this is a DHCP server**.
	- /[resolv.conf](/debianConfig/configurationFiles/etc/resolv.conf.md) - Change DNS on this file after configuring a DNS server IF **this is *NOT* a DHCP server** (it will be automatically changed by [dhcpd.conf])
	- /network
		- /[interfaces](/debianConfig/configurationFiles/etc/network/interfaces.md)
	- /[hostname](/debianConfig/configurationFiles/etc/hostname.md)
`dhcp`
	- /default
		- /[isc-dhcp-server](/debianConfig/configurationFiles/etc/default/isc-dhcp-server.md)
	- /dhcp
		- /[dhcpd.conf](/debianConfig/configurationFiles/etc/dhcp/dhcpd.conf.md)
`dns`
	- /bind
		- /[named.conf.options](/debianConfig/configurationFiles/etc/bind/named.conf.options.md)
		- /[named.conf.local](/debianConfig/configurationFiles/etc/bind/named.conf.local.md)
		- /[exampleDomainName.db](/debianConfig/configurationFiles/etc/bind/exampleDomainName.db.md) - E.g. /zalduabat.db
		- /[db.reversedIp](/debianConfig/configurationFiles/etc/bind/db.reversedIp.md) - E.g. /db.192.168.42
`routing`
	- /[sysctl.conf](/debianConfig/configurationFiles/etc/sysctl.conf.md)
`ldap`
`www`
`docker`
`smb`
`backups`
`task automatisations`