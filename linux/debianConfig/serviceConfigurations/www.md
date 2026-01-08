Apache2 Web page service.
# Index
- [Web page by IP](/linux/debianConfig/serviceConfigurations/www/pageByIp.md)
- [Web page by Domain name](/linux/debianConfig/serviceConfigurations/www/pageByDomainName.md)
- [HTTPS](/linux/debianConfig/serviceConfigurations/www/https.md)

# File index
- [/etc/apache2/ports.conf](/linux/debianConfig/configurationFiles/etc/apache2/ports.conf.md) - TCP port configurations
- [/etc/apache2/sites-available](/linux/debianConfig/configurationFiles/etc/apache2/sites-available/.md) - Web configuration files
- [/etc/apache2/sites-available/000-default.conf](/linux/debianConfig/configurationFiles/etc/apache2/sites-available/000-default.conf/.md) - Web configuration
- [/etc/apache2/sites-available/default-ssl.conf](/linux/debianConfig/configurationFiles/etc/apache2/sites-available/default-ssl.conf/.md) - Configurations with TLS or DNS
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

```powershell title="enable new page"
a2ensite zalduabat.conf
```


```powershell title="disable"
systemctl reload apache2
```