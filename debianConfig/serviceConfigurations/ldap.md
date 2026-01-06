Service to handle users and domains.
# File index
- [/etc/example](/debianConfig/configurationFiles/etc/example.md) - Example

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
nano add_content.ldif
```

```powershell title="server - add_content.ldif - adding user Alice"
dn: uid=alice,ou=People,dc=garitano,dc=eus
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: shadowAccount
uid: alice
givenName: Alice
cn: Alice
Sn: Surname
displayName: Alice
uidNumber: 10000
gidNumber: 5000
userPassword: alice
gecos: Alice
loginShell: /bin/bash
homeDirectory: /home/alice
```

```powershell title="server - generate user"
ldapadd -x -D cn=admin,dc=garitano,dc=eus -W -f add_content.ldif
```

```powershell title="server - see domain entities"
slapcat
```