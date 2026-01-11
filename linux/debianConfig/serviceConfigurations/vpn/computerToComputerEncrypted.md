
VPN connection between two computers.
Encrypted.

## Example structure

Example server: 172.16.0.4/16
Example client: 192.168.1.10/24

# Create key and certificates

```powershell title="server - create key and certificate"
cd /etc/openvpn/server

openssl ecparam -name secp521r1 -genkey -noout -out gakoa.key # Key

openssl req -new -x509 -nodes -days 3650 -key gakoa.key -out zertifikatua.crt -subj "/C=ES/ST=Gipuzkoa/L=Arrasate/O=MGEP/OU=AzpiegiturakEtaSistemak/CN=zerbitzaria" # Certificate
```

```powershell title="client - create key and certificate"
cd /etc/openvpn/client

openssl ecparam -name secp521r1 -genkey -noout -out gakoa.key # Key

openssl req -new -x509 -nodes -days 3650 -key gakoa.key -out zertifikatua.crt -subj "/C=ES/ST=Gipuzkoa/L=Arrasate/O=MGEP/OU=AzpiegiturakEtaSistemak/CN=user" # Certificate
```

# Get fingerprint

```powershell title="server and client - get fingerprint"
openssl x509 -fingerprint -sha256 -in zertifikatua.crt --noout
# sha256 Fingerprint=27:A6:FC:1A:50:91:54:7D:D4:74:0D:40:CB:B9:8C:10:BD:4A:81:97:D6:0A:B5:C3:B1:86:53:83:4F:48:70:63
```

> Note save both server and client fingerprints on a notepad

Optional, see certificate information

```powershell title="client - create key and certificate"
openssl x509 -in zertifikatua.crt -text --noout
```

# Create conf file

```powershell title="server - /etc/openvpn/server/konfigurazioa.conf"
# Basic server configuration
port 443                     # Port where OpenVPN will listen (default: 1194)
proto tcp-server              # Protocol used: UDP or TCP
tls-server                    # Enables TLS and handles server-side TLS handshake

# Optional settings
tun-mtu 1400                  # Maximum packet size in bytes
keepalive 60 300              # Interval to check if the connection is alive or lost

# Network settings
dev ovpn                      # Network interface name
dev-type tun                  # Interface type: TUN or TAP
server 10.8.0.0 255.255.255.0 # Virtual network address and subnet mask for VPN clients
topology subnet               # Virtual network topology: subnet, net30, or p2p

# Keys and certificates
dh none                       # Diffie-Hellman parameters
                               # When set to 'none', Elliptic Curve Diffie-Hellman (ECDH) is used
cert /etc/openvpn/server/zertifikatua.crt  # Server certificate
key  /etc/openvpn/server/gakoa.key          # Server private key

# Client fingerprint verification
<peer-fingerprint>
32:87:EB:0C:41:48:27:59:E1:62:DC:1E:20:4B:1F:D7:57:02:85:F5:2C:F5:A8:28:1B:B3:50:6F:3B:F2:57:F0
</peer-fingerprint>
```

> Note
> Update **client** certificates on this file


```powershell title="client - /etc/openvpn/client/konfigurazioa.conf"
# Basic client configuration
port 443                     # Port where the OpenVPN server is listening (default: 1194)
proto tcp-client              # Protocol used: UDP or TCP
tls-client                    # Enables TLS and performs client-side TLS handshake

# Optional settings
tun-mtu 1400                  # Maximum packet size in bytes
keepalive 60 300              # Interval to detect whether the connection is alive or lost

# Network settings
dev ovpn                      # Network interface name
dev-type tun                  # Interface type: TUN or TAP
pull                          # Accept and apply options pushed by the VPN server

# Keys and certificates
cert /etc/openvpn/client/zertifikatua.crt  # Client certificate
key  /etc/openvpn/client/gakoa.key          # Client private key

# Server fingerprint verification
<peer-fingerprint>
32:87:EB:0C:41:48:27:59:E1:62:DC:1E:20:4B:1F:D7:57:02:85:F5:2C:F5:A8:28:1B:B3:50:6F:3B:F2:57:F0
</peer-fingerprint>
```

> Note
> Update **client** certificates on this file

# Start VPN service

```powershell title="server - create key and certificate"
systemctl start|restart ovpn
# or
# openvpn --config /etc/openvpn/server/konfigurazioa.conf
```

```powershell title="client - create key and certificate"
openvpn --config /etc/openvpn/client/konfigurazioa.conf --remote 172.16.0.4
```

> Note
> Change server IP