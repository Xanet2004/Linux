Use a server as a router to connect different networks.

# File index
- [/etc/sysctl.conf](/debianConfig/configurationFiles/etc/sysctl.conf.md)
- [/etc/network/interfaces](interfaces.md)

# Basic configuration example

```powershell title="Router server"
nano /etc/sysctl.conf
```

```powershell title="/etc/sysctl.conf"
net.ipv4.ip_forward = 1 # 1 -> Turn forwarding on persistently
```

```powershell title="Router server"
sysctl -p # Update changes
```

## Define server1 as gateway router

```powershell title="secondary server - /etc/network/interfaces"
allow-hotplug enp0s18
iface enp0s18 inet static
   address 192.168.44.5/23
   gateway 192.168.44.4 # Server1 as router
```

```powershell title="primary server - /etc/dhcp/dhcpd.conf"
...
option routers 192.168.42.4; # Server1 as router on every zone configurations
...
option routers 192.168.44.4; # Server1 as router on every zone configurations
...
```

```powershell title="secondary server - /etc/dhcp/dhcpd.conf"
...
option routers 192.168.42.4; # Server1 as router on every zone configurations
...
option routers 192.168.44.4; # Server1 as router on every zone configurations
...
```
## Add routes

```powershell title="secondary server - add routes"
ip route add 192.168.42.0/23 via 192.168.44.4
# For devices going to 192.168.42.0 go through 192.168.44.4
```

## Make persistent routes

```powershell title="secondary server - persistent routers - /etc/network/interfaces"
allow-hotplug enp0s18
iface enp0s18 inet static
   address 192.168.44.5/23
   gateway 192.168.44.4 # Server1 as router
   up ip route add 192.168.42.0/23 via 192.168.44.4
   # For devices going to 192.168.42.0 go through 192.168.44.4
```