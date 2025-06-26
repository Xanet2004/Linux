# /etc/network/interfaces

## Palabras clave

auto | allow-hotplug `<interfaz>`

- auto: Inicializar el puerto cuando se inicie el servidor
- allow-hotplug: Inicializar el puerto cuando se intenta establecer una conexión con él.
- Se puede crear una interfaz lógica usando cualquier nombre, pero tener en cuenta las interfaces físicas del dispositivo.

iface `<interfaz>` inet|inet6 `<método>`   # Definición de la interfaz y método de asignación ipv4 o ipv6
    ├─ static
    │    ├─ address `<IP>`
    │    ├─ netmask <máscara>
    │    ├─ gateway `<puerta de enlace>`
    │    ├─ dns-nameservers `<DNS>` (opcional)
    │    └─ bridge_ports `<interfaces>` Para conectar puertos en la misma red (Como compartir puertos de un switch)
    │
    ├─ dhcp
    │    └─ (puede incluir dns-nameservers si quieres DNS personalizados)
    │
    ├─ loopback
    │    └─ (no requiere más parámetros)
    │
    └─ auto (solo para inet6)
         └─ (SLAAC, no requiere parámetros)

# Otros parámetros opcionales que pueden ir dentro de iface:

# mtv, pre-up, post-up, etc. (no mostrados aquí)

## Ejemplo básico

```
# cat /etc/network/interfaces
auto lo -> Se activará la interfaz lo al iniciar el servidor (Esta interfaz se crea lógicamente, no existe físicamente)
iface lo inet loopback -> Se define la interfaz lo como loopback

auto eth0 -> Se activa al iniciar el servidor (Existe físicamente)
iface eth0 inet static -> Se define static para una configuración manual
	address 192.0.2.2
	netmask 255.255.255.0
	gateway 192.0.2.1
iface eth0 inet6 static
	address 2001:DB8:1:3::1
	netmask 56
	gateway 2001:DB8:1::
```

## Ejemplo bridge

```
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
