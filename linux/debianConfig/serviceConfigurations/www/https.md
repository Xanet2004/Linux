
In order to use HTTPS with our pages, we need to generate some certificates.

# HTTPS Configuration

```powershell title="create folder"
mkdir /etc/apache2/ssl # This will save https certificates
```

```powershell title="generate certificate"
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/apache2/ssl/apache.key -out /etc/apache2/ssl/apache.crt
```

- req -x509: generating x509 type certificate
- -nodes: do not encrypt private key
- -days 365: the certificate will be useful for 365 days
- -newkey rsa:2048: using rsa algorithm that will generate a 2048 characters long key
- -keyout: private key name
- -out: certificate name

```powershell title="/etc/apache2/sites-available/zalduabat-ssl.conf"
<IfModule mod_ssl.c>
	<VirtualHost *:443>
		ServerName www.zalduabat.eus
		
		ServerAdmin webmaster@zalduabat.eus
		DocumentRoot /var/www/zalduabat
		
		SSLEngine on
		SSLCertificateFile    /etc/apache2/ssl/apache.crt
		SSLCertificateKeyFile /etc/apache2/ssl/apache.key
		
		ErrorLog ${APACHE_LOG_DIR}/error.log
		CustomLog ${APACHE_LOG_DIR}/access.log combined
	</VirtualHost>
</IfModule>
```

```powershell title="enable ssl module"
a2enmod ssl
```

```powershell title="enable new page"
a2ensite zalduabat.conf
```

```powershell title="disable"
systemctl reload apache2
```

> Important
> You might need to add the page Domain name to the DNS configuration