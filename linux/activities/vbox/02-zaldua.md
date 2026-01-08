This activity's mine purpose is to confirm if the dhcp configuration notes are wrong. Seems to be an error with the connections.

# General view

## Servers
zalduazerb1
- addr0: auto (nat)
- addr1: 192.168.42.4/23
- addr2: 192.168.44.4/23
- dhcp: primary
- Machine configuration:
	- memmory: 2048
	- cpus: 2
	- NIC1 -> nat | mac: 000102030101
	- NIC7 -> intnet: zaldua1 | mac: 000102030107
	- NIC8 -> intent: zaldua2 | mac: 000102030108
	- Partitions: (I won't look much this part for now)
		- primary / y logical swap

zaldua2zerb1
- addr0: auto (nat)
- addr1: 192.168.44.5/23
- dhcp: secondary
- Machine configuration:
	- NIC1 -> nat | mac: 000102030201
	- NIC7 -> intent: zaldua2 | mac: 000102030207
	- Medium: 
		- cloned medium
	- Partitions:
		- cloned

## Clients
zalduabez1
- addr0: auto (nat)
- addr1: dhcp | zaldua1
- Machine configuration:
	- memmory: 2048
	- cpus: 2
	- NIC1 -> nat | mac: 000102031101
	- NIC7 -> intnet: zaldua1 | mac: 000102030117
	- Medium: 
		- 20GB HDD disk
	- Partitions: (I won't look much this part for now)
		- primary / y logical swap

zaldua2bez1
- addr0: auto (nat)
- addr1: dhcp | zaldua2
- Machine configuration:
	- memmory: 2048
	- cpus: 2
	- NIC1 -> nat | mac: 000102031201
	- NIC7 -> intnet: zaldua1 | mac: 000102030217
	- Medium: 
		- 20GB HDD disk
	- Partitions: (I won't look much this part for now)
		- primary / y logical swap

# Network info

Masc: /23 -> 8 + 8 + 7 + 0
11111111.11111111.11111110.00000000
Masc: 255.255.254.0

zaldua1: 192.168.42.0/23
	First: 192.168.42.1 (gateway / vbox gateway: 192.168.42.2)
	Last: 192.168.43.254
	Broadcast: 192.168.43.255

zaldua2: 192.168.44.0/23
	First: 192.168.44.1 (gateway / vbox gateway: 192.168.44.2)
	Last: 192.168.45.254
	Broadcast: 192.168.45.255

# Used vbox commands

We will create zalduazerb1 and then clone it. This way, we don't need to make through the installation process for every machine.

```powershell title="network"
# NETWORK CONF
# network creation
VBoxManage natnetwork add --netname "zaldua1" --network "192.168.42.0/23"
VBoxManage natnetwork add --netname "zaldua2" --network "192.168.44.0/23"

natnetwork start --netname "zaldua1"
natnetwork start --netname "zaldua2"
```

```powershell title="zalduazerb1"
# MACHINE CONF
# zalduazerb1
VBoxManage createvm --name "zalduazerb1" --ostype "Debian_64" --register --basefolder "C:\Users\xanet\VirtualBox VMs\Linux\02-zaldua" --groups "/zaldua1"

# Basic conf
VBoxManage modifyvm "zalduazerb1" --memory 2048 --cpus 2

# NICs
VBoxManage modifyvm "zalduazerb1" --nic1 nat --mac-address1 000102030101
vboxmanage modifyvm "zalduazerb1" --nic7 intnet --mac-address7 000102030107 --intnet7="zaldua1"
vboxmanage modifyvm "zalduazerb1" --nic8 intnet --mac-address8 000102030108 --intnet8="zaldua2"

# ISO controller
VBoxManage storagectl "zalduazerb1" --name "IDE" --add ide --controller PIIX4

# HDD controller
VBoxManage storagectl "zalduazerb1" --name "SATA" --add sata --controller IntelAhci --portcount 1  # we could use a higher port number to attach more than one disks

# ISO attach
VBoxManage storageattach "zalduazerb1" --storagectl "IDE" --port 0 --device 0 --type dvddrive --medium "C:\Users\xanet\SynologyDrive\Study\Mondragon\3. urtea\AzpiegiturakEtaSistemak\ISO\debian-13.2.0-amd64-netinst.iso"

# Create medium
VBoxManage createmedium disk --filename "C:\Users\xanet\VirtualBox VMs\Linux\02-zaldua\zaldua1\zalduazerb1\zalduazerb1-disk" --size "120000" --format VDI
# HDD attach
VBoxManage storageattach "zalduazerb1" --storagectl "SATA" --port 0 --device 0 --type hdd --medium "C:\Users\xanet\VirtualBox VMs\Linux\02-zaldua\zaldua1\zalduazerb1\zalduazerb1-disk.vdi"


# PORT REDIRECTION
VBoxManage modifyvm "zalduazerb1" --natpf1 "ssh,tcp,,2222,,22"


# SNAPSHOT
VBoxManage snapshot "zalduazerb1" take "00_beforeInitialisation" --description="This is the virtual machine before starting it for the first time."


# RUN
VBoxManage startvm "zalduazerb1"
```

```powershell title="zalduabez1"
# MACHINE CONF
# zalduazerb1
VBoxManage createvm --name "zalduabez1" --ostype "Debian_64" --register --basefolder "C:\Users\xanet\VirtualBox VMs\Linux\02-zaldua" --groups "/zaldua1"

# Basic conf
VBoxManage modifyvm "zalduabez1" --memory 2048 --cpus 2

# NIC
vboxmanage modifyvm "zalduabez1" --nic1 nat --mac-address1 000102030111
vboxmanage modifyvm "zalduabez1" --nic7 intnet --mac-address7 000102030117 --intnet7="zaldua1"

# ISO controller
VBoxManage storagectl "zalduabez1" --name "IDE" --add ide --controller PIIX4

# HDD controller
VBoxManage storagectl "zalduabez1" --name "SATA" --add sata --controller IntelAhci --portcount 1  # we could use a higher port number to attach more than one disks

# ISO attach
VBoxManage storageattach "zalduabez1" --storagectl "IDE" --port 0 --device 0 --type dvddrive --medium "C:\Users\xanet\SynologyDrive\Study\Mondragon\3. urtea\AzpiegiturakEtaSistemak\ISO\debian-13.2.0-amd64-netinst.iso"

# Create medium
VBoxManage createmedium disk --filename "C:\Users\xanet\VirtualBox VMs\Linux\02-zaldua\zaldua1\zalduabez1\zalduabez1-disk" --size "120000" --format VDI
# HDD attach
VBoxManage storageattach "zalduabez1" --storagectl "SATA" --port 0 --device 0 --type hdd --medium "C:\Users\xanet\VirtualBox VMs\Linux\02-zaldua\zaldua1\zalduabez1\zalduabez1-disk.vdi"


# SNAPSHOT
VBoxManage snapshot "zalduabez1" take "00_beforeInitialisation" --description="This is the virtual machine before starting it for the first time."


# RUN
VBoxManage startvm "zalduabez1"
```

# Server configuration

Commands used to set up the project