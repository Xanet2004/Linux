
VPN connection between two computers.
No encryption.

```powershell title="server - openvpn"
openvpn --proto tcp-server --dev ovpn --dev-type tun --ifconfig 10.8.0.1 10.8.0.2 --port 443
```

> Note
> This service will be hearing on port TCP 443

```powershell title="client - openvpn"
openvpn --proto tcp-client --dev ovpn --dev-type tun --ifconfig 10.8.0.2 10.8.0.1 --ping 10 --remote 172.16.0.4 443
```

> Note
> VPN packages will go through 10.8.0.1 and 10.8.0.2