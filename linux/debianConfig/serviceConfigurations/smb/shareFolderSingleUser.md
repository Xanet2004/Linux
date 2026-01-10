This configuration will share a folder to a **single user**.

# Share folder

```powershell title="create shared folder"
mkdir /home/user/shared
```

```powershell title="/etc/samba/smb.conf"
[shared] # Whatever name
 comment = Shared directory for user
 browseable = no
 path = /home/user/shared
 read only = no
 writeable = yes
 create mask = 0700
 directory mask = 0700
 valid users = user
```

```powershell title="add user to smb database"
smbpasswd -a user
systemctl restart smbd
```

# User configuration

```powershell title="zaldua1bez2 - installation"
apt insall cifs-utils gvfs-backend
```

```powershell title="file explorer"
smb://smb.zalduabat.eus/shared
```