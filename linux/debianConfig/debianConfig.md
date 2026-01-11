This folder contains notes about Debian configuration commands and files.

The documentation is divided into two types of notes:

- **Service configurations** (SSH, DHCP, DNS, etc.):  
    These notes explain the steps and required settings needed to properly install and configure each service so that it works correctly.
- **Configuration files**:  
    These notes collect and explain the available options and directives found in configuration files, describing what each option does and how it affects the system.

# Index - Service configurations
- [networkInterfaces](/linux/debianConfig/serviceConfigurations/networkInterfaces.md) (networking)
- [openssh](/linux/debianConfig/serviceConfigurations/openssh.md)
- [Users Groups and Permissions](/linux/debianConfig/serviceConfigurations/usersGroupsPermissions.md)
- [dhcp](/linux/debianConfig/serviceConfigurations/dhcp.md)
- [dns](/linux/debianConfig/serviceConfigurations/dns.md)
- [routing](/linux/debianConfig/serviceConfigurations/routing.md)
- [ldap](/linux/debianConfig/serviceConfigurations/ldap.md)
- [www](/linux/debianConfig/serviceConfigurations/www.md)
- [docker](/linux/debianConfig/serviceConfigurations/docker.md)
- [smb](/linux/debianConfig/serviceConfigurations/smb.md)
- [backups](/linux/debianConfig/serviceConfigurations/backups.md) - Segurtasun kopiak
- [task automatisations](/linux/debianConfig/serviceConfigurations/taskAutomatisations.md) - Ataza automatizazioa
- cloud
- [ssh tunnel](/linux/debianConfig/serviceConfigurations/sshTunnel.md)
- [vpn](/linux/debianConfig/serviceConfigurations/vpn.md)
- [example](/linux/debianConfig/serviceConfigurations/example.md) - Example template

# Index - Configuration files
`network interfaces - openssh`
- /etc
	- /[dhcpcd.conf](/linux/debianConfig/configurationFiles/etc/dhcpcd.conf.md) - Change DNS on this file after configuring a DNS server IF **this is a DHCP server**.
	- /[resolv.conf](/linux/debianConfig/configurationFiles/etc/resolv.conf.md) - Change DNS on this file after configuring a DNS server IF **this is *NOT* a DHCP server** (it will be automatically changed by [dhcpd.conf])
	- /network
		- /[interfaces](/linux/debianConfig/configurationFiles/etc/network/interfaces.md)
	- /[hostname](/linux/debianConfig/configurationFiles/etc/hostname.md)
`dhcp`
- /etc
	- /default
		- /[isc-dhcp-server](/linux/debianConfig/configurationFiles/etc/default/isc-dhcp-server.md)
	- /dhcp
		- /[dhcpd.conf](/linux/debianConfig/configurationFiles/etc/dhcp/dhcpd.conf.md)
`dns`
- /etc
	- /bind
		- /[named.conf.options](/linux/debianConfig/configurationFiles/etc/bind/named.conf.options.md)
		- /[named.conf.local](/linux/debianConfig/configurationFiles/etc/bind/named.conf.local.md)
		- /[exampleDomainName.db](/linux/debianConfig/configurationFiles/etc/bind/exampleDomainName.db.md) - E.g. /zalduabat.db
		- /[db.reversedIp](/linux/debianConfig/configurationFiles/etc/bind/db.reversedIp.md) - E.g. /db.192.168.42
`routing`
- /etc
	- /[sysctl.conf](/linux/debianConfig/configurationFiles/etc/sysctl.conf.md)
`ldap`
- /root
	- /ldap
		- /[add_content.ldif](/linux/debianConfig/configurationFiles/root/ldap/add_content.ldif.md)
`www`
- /etc
	- /apache2
		- /sites-available
			- /[000-default.conf](/linux/debianConfig/configurationFiles/etc/apache2/sites-available/000-default.conf.md)
			- /[default-ssl.conf](/linux/debianConfig/configurationFiles/etc/apache2/sites-available/default-ssl.conf.md)
`docker`
`smb`
- /etc
	- /samba
		- /[smb.conf](/linux/debianConfig/configurationFiles/etc/samba/smb.conf.md)
`backups`
- /var
	- /spool
		- /cron
			- /crontabs
				- /[crontab](/linux/debianConfig/configurationFiles/crontab.md)
`task automatisations`