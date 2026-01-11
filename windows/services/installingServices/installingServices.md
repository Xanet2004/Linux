Install required Windows roles and features for AD and DNS.

This installations will be done in BOTH SERVERS.
# Index
- Active Directory
- DNS
- GPMC

# Active Directory

## Dependencies
- Active Directory
- DNS
- GPMC

```powershell title="servers - ad installation"
Add-WindowsFeature -Name "ad-domain-services" -IncludeAllSubFeature -IncludeManagementTools
# Success Restart Needed Exit Code      Feature Result
# ------- -------------- ---------      --------------
# True    No             Success        {Active Directory Domain Services, Group P...
```

# DNS

```powershell title="servers - dns installation"
Add-WindowsFeature -Name "dns" -IncludeAllSubFeature -IncludeManagementTools
# Success Restart Needed Exit Code      Feature Result
# ------- -------------- ---------      --------------
# True    No             Success        {DNS Server, DNS Server Tools}
```

# GPMC

```powershell title="servers - gpc installation"
Add-WindowsFeature -Name "gpmc" -IncludeAllSubFeature -IncludeManagementTools
# Success Restart Needed Exit Code      Feature Result
# ------- -------------- ---------      --------------
# True    No             NoChangeNeeded {}
```

# Snapshot

```powershell title="stop computers"
Stop-Computer -Force
```

```powershell title="snapshots"
VBoxManage snapshot "server1" take "03_servicesInstalled" --description="This is the virtual machine after installing the required services (AD, DNS, GPC)."

VBoxManage snapshot "server2" take "03_servicesInstalled" --description="This is the virtual machine after installing the required services (AD, DNS, GPC)."
```