Manage virtual machine snapshots.

## Example

```powershell
VBoxManage snapshot "zaldua1zerb1" take "00_before_initialisation" --description="This is the virtual machine before starting it for the first time."
```

## Command Options

```powershell
  VBoxManage snapshot <uuid | vmname>

  VBoxManage snapshot <uuid | vmname> take <snapshot-name> [--description=description] [--live]
      [--uniquename Number,Timestamp,Space,Force]

  VBoxManage snapshot <uuid | vmname> delete <snapshot-name>

  VBoxManage snapshot <uuid | vmname> restore <snapshot-name>

  VBoxManage snapshot <uuid | vmname> restorecurrent

  VBoxManage snapshot <uuid | vmname> edit <snapshot-name | --current> [--description=description] [--name=new-name]

  VBoxManage snapshot <uuid | vmname> list [--details | --machinereadable]

  VBoxManage snapshot <uuid | vmname> showvminfo <snapshot-name>
```