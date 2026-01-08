
The web pages can be defined by the IP or the domain name.

# Prerequisites

We need to add a new IP on our server. This IP will be the same as the web page.

```powershell title="add ip"
ip address add 192.168.42.30/24 dev enp0s3
```

# Page Configuration

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

Create a conf file

```powershell title="conf file"
nano /etc/apache2/sites-available/zalduabat.conf
```

```powershell title="/etc/apache2/sites-available/zalduabat.conf"
<VirtualHost *:80>
	ServerName www.zalduabat.eus
	
	ServerAdmin webmaster@zalduabat.eus
	DocumentRoot /var/www/zalduabat
	
	ErrorLog ${APACHE_LOG_DIR}/error.log
	ErrorLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```

```powershell title="enable new page"
a2ensite zalduabat.conf
```

```powershell title="disable"
systemctl reload apache2
```

> Important
> You might need to add the page Domain name to the DNS configuration