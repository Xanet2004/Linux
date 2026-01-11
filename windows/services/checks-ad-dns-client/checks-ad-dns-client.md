This document contains the steps to verify that the Active Directory, DNS, child domain, and client configuration are correct.

# Index
- DNS and Domain Controller Communication
- Child Domain Trust
- Client Login

# Checks
## DNS and Domain Controller Communication
- Verify that all DNS records exist and that communication between domain controllers is working.

```powershell title="server1 - check connectivity"
# DNS resolution (use server1 as DNS)
nslookup proiektuak.edu 192.168.2.101

# Basic network reachability to child DC
ping -n 4 192.168.2.102

# From server1, resolve child domain via server1 DNS
nslookup pbl.proiektuak.edu 192.168.2.101
```

> Outputs: [Server1 - check connectivity](/windows/services/checks-ad-dns-client/outputs/server1-checkConnectivity.md)

```powershell title="server2 - check connectivity"
# DNS resolution (use server2 as DNS)
nslookup pbl.proiektuak.edu 192.168.2.102

# Basic network reachability to root DC
ping -n 4 192.168.2.101

# From server2, resolve root domain via server2 DNS
nslookup proiektuak.edu 192.168.2.102
```

> Outputs: [Server2 - check connectivity](/windows/services/checks-ad-dns-client/outputs/server2-checkConnectivity.md)

### Summary
DNS resolution and network connectivity between root and child domain controllers work correctly, confirming proper communication and delegation.

## Child Domain Trust
- Ensure that a **two-way** and **transitive trust** was automatically created between the Root domain (`proiektuak.edu`) and the Child domain (`pbl.proiektuak.edu`).

```powershell title="server1 - check domain"
# AD view
Get-ADTrust -Filter * | Format-List *

# Lightweight nltest checks (run on each DC)
nltest /domain_trusts
```

> Outputs: [Server1 - check domain](server1-2-checkDomain.md)

### Summary
The automatic **two-way and transitive trust** between the root (`proiektuak.edu`) and child (`pbl.proiektuak.edu`) domains has been correctly created and verified.

## Client Login
- Verify that the client VM can log in with users from the **Root domain** (`proiektuak.edu`) or the **Child domain** (`pbl.proiektuak.edu`) as appropriate.

```powershell title="client - check domain"
# Confirm client domain
(Get-WmiObject Win32_ComputerSystem).Domain
```

```powershell title="client - check local and domain info with different sessions"
# ssh
ssh -p 1113 xetxezarreta@localhost

# Show simple local/domain info
whoami
```

> Outputs: [Client - check session](/windows/services/checks-ad-dns-client/outputs/client-checkSession.md)

### Summary
The client VM can successfully log in using **root domain users**, verifying that the trust and domain integration are working correctly.