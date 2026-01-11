```powershell title="client - check domain"
# Confirm client domain
(Get-WmiObject Win32_ComputerSystem).Domain
```

![[client-checkSession-01.png]]

> Note
> The client is joined to the child domain (pbl.proiektuak.edu), as shown by the Domain property.


```powershell title="client - client - Bezeroa"
# ssh
ssh -p 1113 Bezeroa@localhost

# Show simple local/domain info
whoami
```

![[client-checkSession-02.png]]

> Note
> Local user 'Bezeroa' can log in, confirming basic local access works.


```powershell title="client - client - xetxezarreta"
# ssh
ssh -p 1113 xetxezarreta@localhost

# Show simple local/domain info
whoami
```

![[client-checkSession-03.png]]

```powershell title="client - client - igaritano"
# ssh
ssh -p 1113 igaritano@localhost

# Show simple local/domain info
whoami
```

![[client-checkSession-04.png]]

```powershell title="client - client - xzaldua"
# ssh
ssh -p 1113 xzaldua@localhost

# Show simple local/domain info
whoami
```

![[client-checkSession-05.png]]

```powershell title="client - client - imaritxalar"
# ssh
ssh -p 1113 imaritxalar@localhost

# Show simple local/domain info
whoami
```

![[client-checkSession-06.png]]

> Note
> Root domain users (xzaldua, xetxezarreta, ...) can log in, confirming cross-domain trust is functional.