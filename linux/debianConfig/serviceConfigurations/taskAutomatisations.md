This document shows how to automate backups in Linux using a shell script and `crontab`.
# Index
- [crontab](/linux/debianConfig/configurationFiles/crontab.md)

# Examples

## Run backup.sh script everyday, first hour

```powershell title="script - /home/user/backup.sh"
#!/bin/bash

now=$(date +%Y%m%d_%H%M)

file=/folder_name/home_bakcup_
extension=.tar.bz2

tar -jcPf $file$now$extension /home/user
```

```powershell title="script - /home/user/backup.sh"
chmod +x /home/user/backup.sh
```

```powershell title="edit crontab"
crontab -e
```

```powershell title="crontab"
1 * * * * /home/user/backup.sh
```

> This configuration runs the backup script **every hour at minute 1**.