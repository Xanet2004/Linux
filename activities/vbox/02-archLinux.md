
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
    - Firmware: efi - WE ARE NOT USING EFI BECAUSE VBOX CAN'T HANDLE IT (at least in my laptop)
    - NIC1 → NAT
    - Storage:
        - 40GB x 1 virtual HDD (VDI)
        - Arch Linux ISO for installation
	- Environment HYPRLAND

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
VBoxManage unregistervm "arch1" --delete-all
```

```powershell
# MACHINE CREATION 
VBoxManage createvm --name "arch1" --ostype "ArchLinux_64" --register --basefolder "C:\Users\xanet\VirtualBox VMs\arch\arch1"   --groups "/xanet/arch"

# BASIC CONFIGURATION 
VBoxManage modifyvm "arch1" --memory 4096 --cpus 2 
VBoxManage modifyvm "arch1" --firmware bios

# VIDEO
VBoxManage modifyvm "arch1" --graphicscontroller vmsvga
VBoxManage modifyvm "arch1" --vram 128

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

# System installation for grub

```powershell
archinstall

```

```powershell
VBoxManage snapshot "arch1" take "01_afterInstallation" --description "Clean VM after Arch installation using GRUB"

VBoxManage startvm "arch1"
```

After logging with root user, we see this:
[root@archlinux ~]#

```powershell
loadkeys es

pacman -Syu

pacman -S mesa mesa-demos vulkan-intel xorg-server xorg-xwayland xorg-xhost xorg-xrandr xorg-xinit xorg-xsetroot

# - **mesa / vulkan-intel** → drivers 3D y aceleración   
# - **xorg-xwayland** → para apps X11 en Wayland
# - **xorg-xinit** → para iniciar un entorno gráfico manualmente
# - **xrandr / xhost** → utilidades de pantalla y permisos

pacman -S hyprland xdg-desktop-portal-hyprland swaybg waybar
	2

pacman -S foot alacritty
usermod -aG wheel,video xanet

pacman -S greetd #greeter-greeter
systemctl enable greetd

su - xanet

nano ~/.xinitrc
exec Hyprland


startx

exec Hyprland
```

