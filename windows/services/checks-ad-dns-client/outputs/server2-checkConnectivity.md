```powershell title="server2 - check connectivity"
# DNS resolution (use server1 as DNS)
nslookup proiektuak.edu 192.168.2.101
```

![[/windows/services/checks-ad-dns-client/outputs/img/server2-checkConnectivity/server2-checkConnectivity-01.png]]

> Note
> DNS resolution for the root domain works correctly on Server2.


```powershell title="server2 - check connectivity"
# Basic network reachability to child DC
ping -n 4 192.168.2.102
```

![[/windows/services/checks-ad-dns-client/outputs/img/server2-checkConnectivity/server2-checkConnectivity-02.png]]

> Note
> Server2 can successfully reach the root domain controller, confirming network connectivity.


```powershell title="server2 - check connectivity"
# From server1, resolve child domain via server1 DNS
nslookup pbl.proiektuak.edu 192.168.2.101
```

![[/windows/services/checks-ad-dns-client/outputs/img/server2-checkConnectivity/server2-checkConnectivity-03.png]]

> Note
> Server2 can resolve the child domain via its DNS, showing proper DNS delegation.