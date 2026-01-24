I got the same problems a few times. For some reason, sometimes vbox creates a new dhcpserver with DHCP on. This means that the clients try getting the IPs from that DHCP instead of from where we really want (a custom debian server or whatever)

Check if thats the problem with this command:

```powershell title="check vbox dhcp servers"
VBoxManage list dhcpservers
```

If you see a dhcpserver with DHCP on named like your internal network or something, you should delete it.

Example:

```powershell title="example dhcp problem"
NetworkName: zaldua3 
Dhcpd IP: 192.168.1.130 
LowerIPAddress: 192.168.1.131 
UpperIPAddress: 192.168.1.254 
NetworkMask: 255.255.255.128 
Enabled: Yes ## <--- Hate you!
Global Configuration: 
   minLeaseTime: default 
   defaultLeaseTime: default 
   maxLeaseTime: default 
   Forced options: None 
   Suppressed opts.: None 
   1/legacy: 255.255.255.128 
   3/legacy: 192.168.1.129 
   6/legacy: 212.142.173.64 77.26.11.232 
Groups: None 
Individual Configs: None
```

So... to remove it you can use this command:

```powershell title="remove dhcpserver from vbox"
VBoxManage dhcpserver remove --network "zaldua3"
```