Service to handle users and domains.

# File index
- [/root/ldap/add_content.ldif](/linux/debianConfig/configurationFiles/root/ldap/add_content.ldif.md) - Example

# Installation

```powershell title="installation"
apt update
apt install slapd ldap-utils
```

# Basic configuration example

```powershell title="server - basic ldap conf"
dpkg-reconfigure slapd
> No
> zalduabat.eus
> zaldua
> admin passwd
> No
> Yes

systemctl restart slapd

slapcat # see domain users / entities
```

```powershell title="add user"
mkdir /root/ldap/
nano /root/ldap/add_content.ldif
```

```powershell title="server - /root/ldap/add_content.ldif"
# Add People OU
dn: ou=People,dc=zalduabat,dc=eus
objectClass: organizationalUnit
ou: People

# Add Xanet user
dn: uid=xzaldua,ou=People,dc=zalduabat,dc=eus
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: shadowAccount
uid: xzaldua
cn: Xanet Zaldua
sn: Zaldua
givenName: Xanet
displayName: Xanet Zaldua
uidNumber: 10000
gidNumber: 5000
homeDirectory: /home/xzaldua
loginShell: /bin/bash
userPassword: xzaldua
gecos: Xanet Zaldua
```

```powershell title="server - generate user"
ldapadd -x -D cn=admin,dc=zalduabat,dc=eus -W -f /root/ldap/add_content.ldif
# cn = creators name
```

```powershell title="server - see domain entities"
slapcat
```

# Delete user and OUs

```powershell
ldapdelete -x -D "cn=admin,dc=zalduabat,dc=eus" -W "uid=xzaldua,ou=People,dc=zalduabat,dc=eus"
ldapdelete -x -D "cn=admin,dc=zalduabat,dc=eus" -W "ou=People,dc=zalduabat,dc=eus"

# Or we can create a new file "/root/ldap/remove_content.ldif" and define there the entities
```

# Client configuration

```powershell title="client - installing ldap"
apt install libnss-ldapd libpam-ldapd ldap-utils
> ldap://ldap.zalduabat.eus
> dc=zalduabat,dc=eus
> passwd, group, shadow
```

```powershell title="client - /etc/pam.d/common-session"
...
session required pam_mkhomedir.so umask=0022 skel=/etc/skel
```