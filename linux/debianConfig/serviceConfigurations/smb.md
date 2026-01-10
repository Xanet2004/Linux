DHCP Automatically assigns IP addresses and network settings to devices on a network.
# Index
- [Share a folder to a user](/linux/debianConfig/serviceConfigurations/smb/shareFolderSingleUser.md)
- [Share a folder to a group](/linux/debianConfig/serviceConfigurations/smb/shareFolderGroup.md)

# File index
- [/etc/samba/smb.conf](/linux/debianConfig/configurationFiles/etc/samba/smb.conf.md)

> Samba cannot authenticate **LDAP** users as normal system users.  
> **LDAP** users must include Samba-specific attributes (`sambaSamAccount`) and be managed using Samba–LDAP tools in order to be used for SMB authentication.
# Installation

```powershell title="installation"
apt update
apt install cifs-utils samba
```