# Users
## User Index
- /etc/passwd - Users information
- /etc/shadow - Users private information
## Show users

```powershell title="see users"
cat /etc/passwd
```

```
root:x:0:0:root:/root:/bin/bash
```

| root     | x   | 0       | 0                | root | /root       | /bin | /bash             |
| -------- | --- | ------- | ---------------- | ---- | ----------- | ---- | ----------------- |
| username |     | user id | primary group id |      | user folder |      | user shell perfil |

## User Add Modify and Delete

```powershell title="add modify delete users"
# Simple
adduser # Add
deluser # Delete

# Low level
useradd # Add
userdel # Delete

usermod # Modify
```

### Examples

1. adduser - simple

```
adduser xzaldua
```

- Creates user **xzaldua**
- Creates primary group **xzaldua**
- Creates `/home/xzaldua`
- Copies files from `/etc/skel`
- Asks for and sets password
- Updates `/etc/passwd`, `/etc/shadow`, `/etc/group`

2. useradd - low level

```
useradd -m -s /bin/bash xzaldua
passwd xzaldua
```

- Adds entry to `/etc/passwd`
- Adds entry to `/etc/shadow` (after `passwd`)
- Creates home directory **only if** `**-m**` **is used**
- Does NOT ask interactive questions

3. deluser - simple

```
deluser xzaldua
```

- Removes user entries
- Home directory is **kept by default**

4. userdel - low level

```
userdel xzaldua
```

- Removes user from `/etc/passwd`
- Removes password from `/etc/shadow`
- Removes group references
- Removes `/home/xzaldua` if `-r` is used

5. usermod

```powershell title="Change login name"
usermod -l xzaldua2 xzaldua
```

```powershell title="Change home directory"
usermod -d /home/xzaldua -m xzaldua
```

```powershell title="Change default shell"
usermod -s /bin/zsh xzaldua
```

```powershell title="Add user to a group"
usermod -aG sudo xzaldua
```

- Updates `/etc/passwd`
- Updates `/etc/group`


---
# Groups
## Group Index
- /etc/group - Groups information
- /etc/gshadow - Groups private information
## Show users

```powershell title="see users"
cat /etc/group
```

```
bluetooth:x:111:user
```

| bluetooth | x   | 111      | user        |
| --------- | --- | -------- | ----------- |
| group     |     | group id | group users |

## User Add Modify and Delete

```powershell title="add modify delete groups"
groupadd # add group
groupmod # modify group
groupdel # delete group
adduser user group # add user to a group
deluser user group # delete user from a group
```

---
# Permissions

```
drwxrwxrwx
```

| d         | rwx  | rwx   | rwx    |
| --------- | ---- | ----- | ------ |
| file type | user | group | others |

| char | file type                           |
| ---- | ----------------------------------- |
| -    | Normal file                         |
| d    | Folder / Directory                  |
| l    | Link                                |
| p    | Pipe (Process exit and nexts entry) |
| s    | Socket (two ways pipe)              |
| b    | Block (e.g. /dev/sda1)              |
| c    | Character (e.g. /dev/)              |
## Permission Commands

```powershell title="permission commands"
chmod # Change file type bits
chown # Change file owner
chgrp # Change file group
```

### chmod
**ch**ange file **mod**e bits

#### Text
chmod who=+-permissions filename

```powershell title="chmod - text"
chmod u=rw filename    # User read write                         | rw-------
chmod ugo+rwx filename # User Groups and Others all permissions  | rwxrwxrwx
chmod g-w filename     # Remove writte permission to groups      | e.g. rwxrwxr-- -> rwxr-xr--
```
#### Number
chmod who=+-permissions filename

```powershell title="chmod - number"
chmod 754 filename # | rwxr-xr--
# User    7: 4 + 2 + 1 -> rwx
# Group:  5: 4 + 0 + 1 -> r-x
# Others: 4: 4 + 0 + 0 -> r--

chmod 400 filename # | r--------
# User    4: 4 + 0 + 0 -> r--
# Group:  0: 0 + 0 + 0 -> ---
# Others: 0: 0 + 0 + 0 -> ---

chmod 640 filename # | rw-r-----
# User    6: 4 + 2 + 0 -> rw-
# Group:  4: 4 + 0 + 0 -> r--
# Others: 0: 0 + 0 + 0 -> ---
```

- **7** → rwx
- **6** → rw-
- **5** → r-x
- **4** → r--
- **0** → ---

### chown
**ch**ange file **own**er and group

#### Change owner
chown owner filename

```powershell title="chown - owner"
chown user1 filename
chown user2 filename
```
#### Change owner and group
chown owner:group filename

```powershell title="chown - owner and group"
chown user1:group1 filename
chown user2:group4 filename
```

### chgrp
**ch**ange **gr**ou**p** ownership

#### Change group owner
chgrp group filename

```powershell title="chown - owner"
chgrp group1 filename
chgrp group2 filename
```
