```powershell title="zaldua1bez3"
# MACHINE CONF
# zaldua1bez3
VBoxManage createvm --name "zaldua1bez3" --ostype "Debian_64" --register --basefolder "C:\Users\xanet\VirtualBox VMs\Linux\xanet-zaldua" --groups "/eraikin-nagusia"

# Basic conf
VBoxManage modifyvm "zaldua1bez3" --memory 2048 --cpus 2

# NIC
vboxmanage modifyvm "zaldua1bez3" --nic1 nat --mac-address1 000102030131
vboxmanage modifyvm "zaldua1bez3" --nic2 intnet --mac-address2 000102030132 --intnet2="zaldua1"

# ISO controller
VBoxManage storagectl "zaldua1bez3" --name "IDE" --add ide --controller PIIX4

# HDD controller
VBoxManage storagectl "zaldua1bez3" --name "SATA" --add sata --controller IntelAhci --portcount 1  # we could use a higher port number to attach more than one disks

# ISO attach
VBoxManage storageattach "zaldua1bez3" --storagectl "IDE" --port 0 --device 0 --type dvddrive --medium "C:\Users\xanet\SynologyDrive\Study\Mondragon\3. urtea\AzpiegiturakEtaSistemak\ISO\debian-13.2.0-amd64-netinst.iso"

# Create medium
VBoxManage createmedium disk --filename "C:\Users\xanet\VirtualBox VMs\Linux\xanet-zaldua\eraikin-nagusia\zaldua1bez3\zaldua1bez3-disk" --size "120000" --format VDI
# HDD attach
VBoxManage storageattach "zaldua1bez3" --storagectl "SATA" --port 0 --device 0 --type hdd --medium "C:\Users\xanet\VirtualBox VMs\Linux\xanet-zaldua\eraikin-nagusia\zaldua1bez3\zaldua1bez3-disk.vdi"


# SNAPSHOT
VBoxManage snapshot "zaldua1bez3" take "00_beforeInitialisation" --description="This is the virtual machine before starting it for the first time."


# RUN
VBoxManage startvm "zaldua1bez3"
```