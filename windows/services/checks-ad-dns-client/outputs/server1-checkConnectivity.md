```powershell title="server1 - check connectivity"
# DNS resolution (use server1 as DNS)
nslookup proiektuak.edu 192.168.2.101
```

![[server1-checkConnectivity-01.png]]

> Note
> DNS resolution for the root domain works correctly on Server1.


```powershell title="server1 - check connectivity"
# Basic network reachability to child DC
ping -n 4 192.168.2.102
```

![[/windows/services/checks-ad-dns-client/outputs/img/server1-checkConnectivity/server1-checkConnectivity-02.png]]

> Note
> Server1 can successfully reach the child domain controller, confirming network connectivity.


```powershell title="server1 - check connectivity"
# From server1, resolve child domain via server1 DNS
nslookup pbl.proiektuak.edu 192.168.2.101
```

![[server1-checkConnectivity-03.png]]

> Note
> Server1 can resolve the child domain via its DNS, showing proper DNS delegation.