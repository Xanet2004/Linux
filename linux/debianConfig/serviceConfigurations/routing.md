Use a server as a router to connect different networks.

# File index
- [/etc/sysctl.conf](/linux/debianConfig/configurationFiles/etc/sysctl.conf.md)
- [/etc/network/interfaces](/linux/debianConfig/configurationFiles/etc/network/interfaces.md)

# Basic configuration example

```powershell title="installation"
apt install iptables iptables-persistent
```

```powershell title="Router server"
nano /etc/sysctl.conf
```

```powershell title="/etc/sysctl.conf"
net.ipv4.ip_forward = 1 # 1 -> Turn forwarding on persistently
```

> Important
> Seems that in new debian machines this file just doesn't work. We need to configure the next one:

```powershell title="Router server"
nano /etc/sysctl.d/99-ipforward.conf
```

```powershell title="/etc/sysctl.d/99-ipforward.conf"
net.ipv4.ip_forward = 1 # 1 -> Turn forwarding on persistently
```

```powershell title="Router server"
systemctl enable systemd-sysctl
systemctl start systemd-sysctl
sysctl -p # Update changes
```

```powershell title="Nat and forward rules"
# Masquerade traffic coming from the 192.168.42.0/23 network
# This rewrites the source IP to the IP of enp0s3 (Internet-facing interface)
iptables -t nat -A POSTROUTING -s 192.168.42.0/23 -o enp0s3 -j MASQUERADE

# Masquerade traffic coming from the 192.168.44.0/23 network
# This allows hosts in this subnet to access the Internet
iptables -t nat -A POSTROUTING -s 192.168.44.0/23 -o enp0s3 -j MASQUERADE


# Allow forwarding of packets from internal network 192.168.42.0/23 to the Internet
iptables -A FORWARD -s 192.168.42.0/23 -o enp0s3 -j ACCEPT

# Allow forwarding of packets from internal network 192.168.44.0/23 to the Internet
iptables -A FORWARD -s 192.168.44.0/23 -o enp0s3 -j ACCEPT

# Allow return traffic for already established or related connections
# This is required so replies from the Internet are accepted
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

# Save
netfilter-persistent save
```

## Define server1 as gateway router

```powershell title="primary server - /etc/network/interfaces"
allow-hotplug enp0s18
iface enp0s18 inet static
   address 192.168.44.5/23
   gateway 192.168.44.2 # Outside Router ip
```

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