
**Windows host + Arch Linux virtual machine**

This activity is focused on installing and understanding a **basic Arch Linux system** running on **Windows using VirtualBox**.  
The goal is to get a minimal but functional Linux environment that can later be extended with desktop environments, networking experiments or services if needed.

No server roles (DHCP, DNS, etc.) are configured in this activity.   

---

### Virtual machine

**arch1**

- OS: **Arch Linux (x86_64)**
- Network: NAT (internet access)
- Machine configuration:
    - Memory: **4096 MB**
    - CPUs: **2**
    - Firmware: efi
    - NIC1 → NAT
    - Storage:
        - 40GB x 1 virtual HDD (VDI)
        - Arch Linux ISO for installation

This machine will be used as a **base system** and can later be cloned to avoid reinstalling Arch multiple times.

---

## Network info

### NAT networking

- Network mode: **NAT**
- IP assignment: **Automatic (VirtualBox DHCP)**
- Internet access: ✅ Yes
- Host ↔ VM communication: limited (default NAT behavior)

No custom IP addressing or internal networks are required for this activity.

---

## Used VirtualBox commands

We create a **single Arch Linux VM** from scratch.

```powershell title="remove the machine"
VBoxManage unregistervm "arch1" --delete
```

```powershell
# MACHINE CREATION 
VBoxManage createvm --name "arch1" --ostype "ArchLinux_64" --register --basefolder "C:\Users\xanet\VirtualBox VMs\arch\arch1"   --groups "/xanet/arch"

# BASIC CONFIGURATION 
VBoxManage modifyvm "arch1" --memory 4096 --cpus 2 

# FIRMWARE
VBoxManage modifyvm "arch1" --firmware efi

# VIDEO ADAPERT (To fix efi)
VBoxManage modifyvm "arch1" --graphicscontroller vmsvga
VBoxManage modifyvm "arch1" --vram 128
VBoxManage modifyvm "arch1" --accelerate3d off
VBoxManage modifyvm "arch1" --monitorcount 1
VBoxManage modifyvm "arch1" --vrde off
VBoxManage modifyvm "arch1" --usb off
VBoxManage modifyvm "arch1" --pae on
VBoxManage modifyvm "arch1" --hwvirtex on


# NETWORK 
VBoxManage modifyvm "arch1" --nic1 nat  

# STORAGE CONTROLLERS 
# SATA controller for the hard disk 
VBoxManage storagectl "arch1" --name "SATA" --add sata --controller IntelAhci --portcount 1

# IDE controller for the ISO 
VBoxManage storagectl "arch1" --name "IDE" --add ide --controller PIIX4  

# HDD CREATION 
VBoxManage createmedium disk --filename "C:\Users\xanet\VirtualBox VMs\arch\arch1\arch1.vdi" --size 40000 --format VDI

# HDD ATTACH 
VBoxManage storageattach "arch1" --storagectl "SATA" --port 0 --device 0 --type hdd --medium "C:\Users\xanet\VirtualBox VMs\arch\arch1\arch1.vdi"  
# ISO ATTACH (Arch Linux installer) 
VBoxManage storageattach "arch1" --storagectl "IDE" --port 0 --device 0 --type dvddrive --medium "C:\Users\xanet\SynologyDrive\Study\Mondragon\3. urtea\AzpiegiturakEtaSistemak\ISO\archlinux-2026.01.01-x86_64.iso"  


# SNAPSHOT 
VBoxManage snapshot "arch1" take "00_beforeInstallation" --description "Clean VM before Arch installation"  

# EFI FIX (MOVE TEMPORALLY HDD TO IDE CONTROLLER)

VBoxManage storageattach "arch1" --storagectl "SATA" --medium none --port 0 --device 0
VBoxManage storageattach "arch1" --storagectl "IDE" --port 1 --device 0 --type hdd --medium "arch1.vdi"


# START VM 
VBoxManage startvm "arch1"
```

```powershell
VBoxManage modifyvm "arch1" --boot1 disk --boot2 none --boot3 none --boot4 none

VBoxManage startvm "arch1"
```

---

## Notes

- Arch Linux will be installed manually following the **Arch Wiki Installation Guide**
    
- This VM is intended as a **base image**
    
- After installation, a snapshot can be taken and the VM cloned for further activities
    
- Desktop environment, window manager or additional software are **out of scope** for this activity

---

# System installation

```powershell
loadkeys es
ping -c 3 archlinux.org
lsblk
cfdisk /dev/sda
	- EFI → 512M → tipo EFI
	- Root → resto → Linux filesystem

mkfs.fat -F32 /dev/sda1
mkfs.ext4 /dev/sda2

mount /dev/sda2 /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot

pacstrap /mnt base linux linux-firmware

genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt

ln -sf /usr/share/zoneinfo/Europe/Madrid /etc/localtime
hwclock --systohc

pacman -S nano dhcpcd

nano /etc/locale.gen

nano /etc/locale.gen
	en_US.UTF-8 UTF-8
	es_ES.UTF-8 UTF-8

locale-gen

echo "LANG=es_ES.UTF-8" > /etc/locale.conf

echo "archlinux" > /etc/hostname

nano /etc/hosts

	127.0.0.1   localhost
	::1         localhost
	127.0.1.1   archlinux.localdomain archlinux

pacman -S grub efibootmgr

grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB

grub-mkconfig -o /boot/grub/grub.cfg

passwd
	root
	root

useradd -m -G wheel xanet
passwd xanet

pacman -S sudo
EDITOR=nano visudo
	%wheel ALL=(ALL) ALL

pacman -S networkmanager
systemctl enable NetworkManager

exit
umount -R /mnt
reboot

```