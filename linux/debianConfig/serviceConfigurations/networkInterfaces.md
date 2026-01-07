This file will setup a basic network interface configuration.

```powershell title="default conf"
# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
allow-hotplug enp0s3
iface enp0s3 inet dhcp
# This is an autoconfigured IPv6 interface
iface enp0s3 inet6 auto
```

We have to change that configuration and enable our network interfaces.

For example, I need to enable enp0s18 and enp0s19 and set static IPs to them.

```powershell title="basic conf"
# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
allow-hotplug enp0s3
iface enp0s3 inet dhcp
# This is an autoconfigured IPv6 interface
allow-hotplug enp0s18
iface enp0s18 inet static
   address 192.168.42.4/23
   gateway 192.168.42.2

allow-hotplug enp0s19
iface enp0s19 inet static
   address 192.168.44.4/23
   gateway 192.168.44.2
```

And now restart the networking services

```powershell title="networking"
systemctl restart networking
ifup enp0s18
ifup enp0s19
```

## DHCP network problem

ifdown enp0s18
ifup enp0s18
ip addr flush dev enp0s18
systemctl restart networking