Attach, remove, and modify storage media used by a virtual machine.
## Example

```powershell
# HDD DISK
VBoxManage storageattach "zaldua1zerb1" --storagectl "SATA" --port 0 --device 0 --type hdd --medium "C:\Users\xanet\VirtualBox VMs\Linux\xanet-zaldua\eraikin-nagusia\zaldua1zerb1\zaldua1zerb1-disk.vdi"

# ISO
VBoxManage storageattach "zaldua1zerb1" --storagectl "IDE" --port 0 --device 0 --type dvddrive --medium "C:\Users\xanet\SynologyDrive\Study\Mondragon\3. urtea\AzpiegiturakEtaSistemak\ISO\debian-13.2.0-amd64-netinst.iso"
```

## Command Options

```powershell
VBoxManage storageattach <uuid | vmname> <--storagectl=name> [--bandwidthgroup= name | none] [--comment=text]
      [--device=number] [--discard= on | off] [--encodedlun=lun] [--forceunmount] [--hotpluggable= on | off]
      [--initiator=initiator] [--intnet] [--lun=lun] [--medium= none | emptydrive | additions | uuid | filename |
      host:drive | iscsi] [--mtype= normal | writethrough | immutable | shareable | readonly | multiattach]
      [--nonrotational= on | off] [--passthrough= on | off] [--passwordfile=file] [--password=password] [--port=number]
      [--server= name | ip] [--setparentuuid=uuid] [--setuuid=uuid] [--target=target] [--tempeject= on | off]
      [--tport=port] [--type= dvddrive | fdd | hdd] [--username=username]
```