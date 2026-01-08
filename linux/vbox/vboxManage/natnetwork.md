Usage - Create, modify, and manage a NAT network.

> Important
> Nat network won't work if we are using inet (internal net) interfaces
## Example

```powershell
VBoxManage natnetwork add --netname "zaldua1" --network "192.168.42.0/23"
VBoxManage natnetwork start --netname "zaldua1"
```

```powershell title="Port forwarding"
VBoxManage natnetwork modify --netname "zaldua1" --port-forward-4 "ssh:tcp:[127.0.0.1]:2222:[10.0.2.15]:22"
```
## Command Options

- VBoxManage natnetwork add [--disable | --enable] <--netname=name> <--network=network> [--dhcp=on|off] [--ipv6=on|off] [--loopback-4=rule] [--loopback-6=rule] [--port-forward-4=rule] [--port-forward-6=rule]

- VBoxManage natnetwork list [filter-pattern]

- VBoxManage natnetwork modify [--dhcp=on|off] [--disable | --enable] <--netname=name> <--network=network> [--ipv6=on|off] [--loopback-4=rule] [--loopback-6=rule] [--port-forward-4=rule] [--port-forward-6=rule]

- VBoxManage natnetwork remove <--netname=name>

- VBoxManage natnetwork start <--netname=name>

- VBoxManage natnetwork stop <--netname=name>