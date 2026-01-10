This configuration will share a folder to a **group**.

# Share folder

```powershell title="create shared folder"
mkdir /home/user/sharedformembers
```

```powershell title="/etc/samba/smb.conf"
[groupmembers] # Whatever name
 comment = Shared directory for a specific group members
 browseable = no
 path = /home/user/sharedformembers
 read only = no
 writeable = yes
 create mask = 0700
 directory mask = 0700
 valid users = @members
 force group = members
```

```powershell title="add user to smb database"
smbpasswd -a user
```

```powershell title="add new example user"
adduser user2
smbpasswd -a user2
```

```powershell title="add group members"
addgroup members
adduser user members
adduser user2 members
chgrp members /home/user/sharedformembers
```

```powershell title="restart smb"
systemctl restart smbd
```

```powershell title="test smb users"
pdbedit -L
# user:1000:user
# user2:1001:
```
# User configuration

```powershell title="zaldua1bez2 - installation"
apt insall cifs-utils gvfs-backend
```

```powershell title="file explorer"
smb://smb.zalduabat.eus/sharedformembers
```