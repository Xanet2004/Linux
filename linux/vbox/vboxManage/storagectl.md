Manage a storage **controller**.
A **storage controller (`storagectl`)** defines **how a VM connects to disks** (type, ports, and bus).
## Example

```powershell
# HDD DISK
VBoxManage storagectl "zaldua1zerb1" --name "SATA" --add sata --controller IntelAhci --portcount 1

# ISO
VBoxManage storagectl "zaldua1zerb1" --name "IDE" --add ide --controller PIIX4
```

## Command Options

```powershell
VBoxManage storagectl <uuid | vmname> <--name=controller-name> [--add= floppy | ide | pcie | sas | sata | scsi | usb]
      [--controller= BusLogic | I82078 | ICH6 | IntelAhci | LSILogic | LSILogicSAS | NVMe | PIIX3 | PIIX4 | USB |
      VirtIO] [--bootable= on | off] [--hostiocache= on | off] [--portcount=count] [--remove]
      [--rename=new-controller-name]
```