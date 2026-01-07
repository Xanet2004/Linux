Create a new medium

Can be disk dvd or floppy

## Example

```powershell
VBoxManage createmedium disk --filename "C:\Users\xanet\VirtualBox VMs\Linux\xanet-zaldua\eraikin-nagusia\zaldua1zerb1\zaldua1zerb1-disk" --size "120000" --format VDI
```

## Command Options

```powershell
VBoxManage createmedium [disk | dvd | floppy] <--filename=filename> [--size=megabytes | --sizebyte=bytes]
      [--diffparent= UUID | filename] [--format= VDI | VMDK | VHD]
      [--variant=Standard|Fixed|Split2G|Stream|ESX|Formatted|RawDisk...] [--property=name=value...]
      [--property-file=name=/path/to/file/with/value...]
```