This file is used to add entries (organizational units and users) to an LDAP directory.
It demonstrates creating an OU (`People`) and a user (`Xanet Zaldua`) in LDAP.

---

# Basic example

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

---
## 1️⃣ Organizational Unit (OU)

```powershell
# Add People OU 
dn: ou=People,dc=zalduabat,dc=eus 
objectClass: organizationalUnit 
ou: People
```

|Attribute|Purpose|
|---|---|
|`dn` (Distinguished Name)|Full path of the entry in LDAP tree. Must be unique. Here: OU `People` under domain `zalduabat.eus`.|
|`objectClass`|Defines the type of LDAP entry. `organizationalUnit` is used for OUs.|
|`ou`|The name of the organizational unit. This is usually the value used in `dn`.|

> **Note:** You must create the OU before adding users under it.

---
## 2️⃣ User Entry

```powershell
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

|Attribute|Purpose|
|---|---|
|`dn`|Distinguished Name for the user. Must include `uid` and the OU.|
|`objectClass`|Defines the type of entry.  <br>- `inetOrgPerson`: general user info (name, email, etc.)  <br>- `posixAccount`: Linux user account info (UID, GID, shell, home)  <br>- `shadowAccount`: password aging info for Linux systems.|
|`uid`|User ID (login name). Must be unique within the domain.|
|`cn`|Common Name. Typically full name of the user (used for display).|
|`sn`|Surname / last name.|
|`givenName`|First name.|
|`displayName`|How the name is shown in applications. Usually full name.|
|`uidNumber`|Numeric user ID (Linux/UNIX).|
|`gidNumber`|Primary group ID.|
|`homeDirectory`|Home directory path for Linux/UNIX accounts.|
|`loginShell`|Default shell for Linux/UNIX accounts.|
|`userPassword`|Password. Can be plain text (not recommended) or hashed with `slappasswd`.|
|`gecos`|Optional field, usually the full name. Used in `/etc/passwd`.|

---

## 3️⃣ Tips & Best Practices

1. **OU Creation First**: Always create the OU before adding users under it.
2. **DN Must Be Unique**: Each `dn` must not already exist.
3. **Attribute Case**: LDAP attributes are **case-insensitive**, but best practice is lowercase for standard attributes (`sn`, `givenName`).
4. **Password**: Use hashed passwords with `slappasswd` instead of plain text.
5. **Consistency**: Keep `cn`, `displayName`, and `gecos` consistent for clarity.
6. **UID and GID Numbers**: Avoid collisions with system accounts; usually start with 10000 for custom LDAP users.