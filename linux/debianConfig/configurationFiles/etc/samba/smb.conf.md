# Index
- Atal ezberdinetan banatua 
- Global Settings
- Browsing/Identification
- Networking
- Debugging/Accounting
- Authentication
- Domains
- Misc
- **Share Definitions**

We are going to change share definitions

# Share Definitions

In Samba, a “share” is a directory or resource you make available over the network. Each share is defined in `smb.conf` as a section:

```powershell title="share definition"
[sharename] # could have any name
```

Below is a detailed explanation of the most commonly used parameters:

```powershell
[shared]                                             # Name of the share as seen by clients
	comment = Shared directory for a specific user   # Optional description     
	path = /home/user/shared                         # Filesystem path of the share      
	browseable = yes/no                              # Determines if the share is visible in network browsing     
	read only = yes/no                               # If yes, clients cannot write     
	writeable = yes/no                               # Synonym for read only=no     
	guest ok = yes/no                                # Allows access without a Samba user account     
	valid users = user1, @group1                     # Only these users/groups can access     
	invalid users = user2, @group2                   # Users explicitly denied     
	force user = user                                # Forces filesystem operations as this Unix user     
	force group = group                              # Forces group ownership     
	create mask = 0660                               # Default permissions for new files (Unix mask)     
	directory mask = 0770                            # Default permissions for new directories     
	directory mode/force create mask = ...           # Alternative syntax in newer Samba versions     
	force create mode = 0660                         # Force specific permission bits     
	force directory mode = 0770                      # Force specific directory bits     
	inherit permissions = yes/no                     # New files inherit parent directory permissions     
	inherit acls = yes/no                            # Inherit NTFS ACLs from parent     
	follow symlinks = yes/no                         # Allow following symlinks    
	wide links = yes/no                              # Allow symlinks to point outside share     
	hide files = *.tmp, ~*                           # Hide matching filenames from clients     
	veto files = *.exe, *.dll                        # Completely block matching filenames     
	vfs objects = recycle, shadow_copy2, full_audit  # Load VFS modules for extra features     
	recycle:repository = /tmp/.recycle               # Directory for Recycle Bin module     
	recycle:keeptree = yes/no                        # Keep original folder tree in recycle bin     
	recycle:versions = yes/no                        # Keep versions of deleted files     
	browseable = yes/no                              # Whether share is visible in browsing     
	case sensitive = yes/no                          # How case sensitivity is handled     
	short preserve case = yes/no                     # Preserve case on short filenames     
	strict allocate = yes/no                         # Force Samba to allocate file space at creation     
	strict locking = yes/no                          # Enforce strict file locking     
	oplocks = yes/no                                 # Enable Opportunistic Locking     
	level2 oplocks = yes/no                          # Enable level 2 oplocks for multiple clients     
	locking = yes/no                                 # Enable/disable SMB locking     
	host allow = 192.168.42.0/23, 10.0.0.0/24        # Only allow these hosts to access     
	host deny = 192.168.1.0/24                       # Deny access from these hosts
```

### Notes:

- **`read only` vs `writeable`**: `writeable = yes` is equivalent to `read only = no`. Both can coexist for clarity.
- **User and group restrictions**: Use `@groupname` to refer to a Unix group.
- **Permissions**: Mask values are Unix permission masks (octal).
- **VFS modules**: Add functionality like recycle bin, auditing, shadow copies, virus scanning, etc.
- **Symlinks**: By default, Samba may restrict links outside the share; use `wide links` carefully for security.
- **Access control**: `host allow/deny` is network-level, `valid users/invalid users` is account-level.

---

#### Example – Minimal user share

```powershell title="example share"
[shared]
	comment = User personal shared folder
	path = /home/user/shared
	browseable = no
	read only = no
	valid users = user
	create mask = 0700
	directory mask = 0700
```

This configuration:

- Makes the folder **non-browseable** (hidden in network list)
- Allows only **user** to read/write
- Files and directories are created with **private permissions**