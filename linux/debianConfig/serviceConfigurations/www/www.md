Apache2 Web page service.
# Index
- [Web page by IP](/linux/debianConfig/serviceConfigurations/www/pageByIp.md)
- [Web page by Domain name](/linux/debianConfig/serviceConfigurations/www/pageByDomainName.md)
- [HTTPS](/linux/debianConfig/serviceConfigurations/www/https.md)

# File index
- [/etc/apache2/ports.conf](/linux/debianConfig/configurationFiles/etc/apache2/ports.conf.md) - TCP port configurations
- [/etc/apache2/sites-available](/linux/debianConfig/configurationFiles/etc/apache2/sites-available.md) - Web configuration files
- [/etc/apache2/sites-available/000-default.conf](/linux/debianConfig/configurationFiles/etc/apache2/sites-available/000-default.conf.md) - Web configuration
- [/etc/apache2/sites-available/default-ssl.conf](/linux/debianConfig/configurationFiles/etc/apache2/sites-available/default-ssl.conf.md) - Configurations with TLS or DNS
- [/etc/apache2/sites-enabled](/linux/debianConfig/configurationFiles/etc/apache2/sites-enabled.md)
- [/etc/apache2/mods-available](/linux/debianConfig/configurationFiles/etc/apache2/mods-available.md)
- [/etc/apache2/mods-enabled](/linux/debianConfig/configurationFiles/etc/apache2/mods-enabled.md)

# Installation

```powershell title="installation"
apt update
apt install apache2
```

# Basic configuration

```powershell title="disable default page"
a2dissite 000-default.conf
```

```powershell title="conf file"
nano /etc/apache2/sites-available/zalduabat.conf
```

```powershell title="/etc/apache2/sites-available/zalduabat.conf"
<VirtualHost 192.168.42.30:80>
	#ServerName www.zalduabat.eus
	
	ServerAdmin webmaster@zalduabat.eus
	DocumentRoot /var/www/zalduabat
	
	ErrorLog ${APACHE_LOG_DIR}/error.log
	CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```

```powershell title="create folder"
mkdir /var/www/zalduabat
```

```powershell title="/var/www/zalduabat/index.html"
<html>
	<head>
		<title>www.zalduabat.eus</title>
	</head>
	<body>
		<center>www.zalduabat.eus</center>
	</body>
</html>
```

> Note
> You can add a previously compiled frontend page here.
> So it works easily with any framework app. Basic html, React, Astro, ...

```powershell title="add ip"
ip address add 192.168.42.30/24 dev enp0s18


# Static ip with network/interfaces
# iface enp0s18 inet static
#    address 192.168.42.4/23
#
# iface enp0s18 inet static
#    address 192.168.42.30/23
```

```powershell title="enable new page"
a2ensite zalduabat.conf
```


```powershell title="disable"
systemctl reload apache2
```