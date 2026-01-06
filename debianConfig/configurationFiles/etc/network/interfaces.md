/etc/network/interfaces

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

# Key words

auto | allow-hotplug `<interface>`

- auto: Initialize the port when the server starts
- allow-hotplug: Initialize the port when a connection is attempted
- You can create a logical interface using any name, but keep the physical device interfaces in mind. 
  Example: lo -> loopback

iface `<interface>` inet|inet`<method>`  # Defines the interface and IPv4/IPv6 assignment method

Methods:
  - static
      - address `<IP>`
      - netmask `<netmask>`
      - gateway `<gateway>`
      - dns-nameservers `<DNS>` (optional)
      - bridge_ports `<interfaces>`  # Connect multiple ports on the same network (like sharing switch ports)
      - persistent routes # up ip route add 192.168.42.0/23 via 192.168.44.4

  - dhcp
      - (can include dns-nameservers if you want custom DNS)

  - loopback
      - (requires no additional parameters)

  - auto (only for inet6)
      - (SLAAC, requires no parameters)

# Bridge example

```powershell title="bridge basic conf"
auto enp4s0 -> Crear la interfaz necesaria
iface enp4s0 inet manual

auto enp8s0 -> Crear la interfaz necesaria
iface enp8s0 inet manual

auto bond0 -> Para conectar las interfaces mediante el uso de slaves
iface bond0 inet manual
	slaves enp4s0 enp8s0
	bond-mode 802.3ad

auto br0
iface br0 inet static
	address 192.168.1.17
	netmask 255.255.255.0
	network 192.168.1.0
	broadcast 192.168.1.255
	gateway 192.168.1.1
	bridge_ports bond0 -> Definir bridge en las interfaces necesarias
	bridge_stp off
	bridge_fd 0
	bridge_maxwait 0
```

# Persistent route

```powershell title="persistent route example"
allow-hotplug enp0s18
iface enp0s18 inet static
   address 192.168.44.5/23
   gateway 192.168.44.4 # Server1 as router
   up ip route add 192.168.42.0/23 via 192.168.44.4
   # For devices going to 192.168.42.0 go through 192.168.44.4
```