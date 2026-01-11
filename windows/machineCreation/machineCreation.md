Steps to create and configure virtual machines and networking using VBox.

Installation process: [Installations](/windows/machineInstallation/machineInstallation.md)
# Network requisites

| Property         | Configuration  |
| ---------------- | -------------- |
| **Network Name** | wpopblnetwork  |
| **Subnet**       | 192.168.2.0/24 |
| **DHCP**         | Disabled       |
| **Type**         | natnetwork     |

# Network creation

```powershell title="network creation"
VBoxManage natnetwork add --netname "wpopblnetwork" --network "192.168.2.0/24" --dhcp=off
```

```powershell title="port forwarding"
# SSH
VBoxManage natnetwork modify --netname "wpopblnetwork" --port-forward-4 "server1-ssh:tcp:[127.0.0.1]:1111:[192.168.2.101]:22"

VBoxManage natnetwork modify --netname "wpopblnetwork" --port-forward-4 "server2-ssh:tcp:[127.0.0.1]:1112:[192.168.2.102]:22"

VBoxManage natnetwork modify --netname "wpopblnetwork" --port-forward-4 "client-ssh:tcp:[127.0.0.1]:1113:[192.168.2.200]:22"

# RDP
VBoxManage natnetwork modify --netname "wpopblnetwork" --port-forward-4 "Allow RDP to Server1:tcp:[127.0.0.1]:8888:[192.168.2.101]:3389"

VBoxManage natnetwork modify --netname "wpopblnetwork" --port-forward-4 "Allow RDP to Server2:tcp:[127.0.0.1]:8889:[192.168.2.102]:3389"

VBoxManage natnetwork modify --netname "wpopblnetwork" --port-forward-4 "Allow RDP to Client:tcp:[127.0.0.1]:8890:[192.168.2.200]:3389"
```

```powershell title="start network"
VBoxManage natnetwork start --netname "wpopblnetwork"
```

# Server 1

```powershell title="server1 creation"
# MACHINE CONF
# server1
VBoxManage createvm --name "server1" --ostype "Windows2025_64" --register --basefolder "C:\Users\xanet\VirtualBox VMs\Windows\xanet-zaldua" --groups "/popbl"
# ID / Description: Windows2025_64 -- Windows Server 2025 (64-bit)

# Basic conf
VBoxManage modifyvm "server1" --memory 2048 --cpus 2

# NICs
VBoxManage modifyvm "server1" --nic1 natnetwork --mac-address1 000102030411 --nat-network1 wpopblnetwork

# ISO controller
VBoxManage storagectl "server1" --name "IDE" --add ide --controller PIIX4

# HDD controller
VBoxManage storagectl "server1" --name "SATA" --add sata --controller IntelAhci --portcount 1  # we could use a higher port number to attach more than one disks

# ISO attach
VBoxManage storageattach "server1" --storagectl "IDE" --port 0 --device 0 --type dvddrive --medium "C:\Users\xanet\Temp\26100.1742.240906-0331.ge_release_svc_refresh_SERVER_EVAL_x64FRE_en-us.iso"

# Create medium
VBoxManage createmedium disk --filename "C:\Users\xanet\VirtualBox VMs\Windows\xanet-zaldua\popbl\server1\server1-disk" --size "120000" --format VDI
# HDD attach
VBoxManage storageattach "server1" --storagectl "SATA" --port 0 --device 0 --type hdd --medium "C:\Users\xanet\VirtualBox VMs\Windows\xanet-zaldua\popbl\server1\server1-disk.vdi"


# SNAPSHOT
VBoxManage snapshot "server1" take "00_beforeInitialisation" --description="This is the virtual machine before starting it for the first time."


# RUN
VBoxManage startvm "server1"
```

# Server 2

```powershell title="server2 creation"
# MACHINE CONF
# server2
VBoxManage createvm --name "server2" --ostype "Windows2025_64" --register --basefolder "C:\Users\xanet\VirtualBox VMs\Windows\xanet-zaldua" --groups "/popbl"
# ID / Description: Windows2025_64 -- Windows Server 2025 (64-bit)

# Basic conf
VBoxManage modifyvm "server2" --memory 2048 --cpus 2

# NICs
VBoxManage modifyvm "server2" --nic1 natnetwork --mac-address1 000102030412 --nat-network1 wpopblnetwork

# ISO controller
VBoxManage storagectl "server2" --name "IDE" --add ide --controller PIIX4

# HDD controller
VBoxManage storagectl "server2" --name "SATA" --add sata --controller IntelAhci --portcount 1  # we could use a higher port number to attach more than one disks

# ISO attach
VBoxManage storageattach "server2" --storagectl "IDE" --port 0 --device 0 --type dvddrive --medium "C:\Users\xanet\Temp\26100.1742.240906-0331.ge_release_svc_refresh_SERVER_EVAL_x64FRE_en-us.iso"

# Create medium
VBoxManage createmedium disk --filename "C:\Users\xanet\VirtualBox VMs\Windows\xanet-zaldua\popbl\server2\server2-disk" --size "120000" --format VDI
# HDD attach
VBoxManage storageattach "server2" --storagectl "SATA" --port 0 --device 0 --type hdd --medium "C:\Users\xanet\VirtualBox VMs\Windows\xanet-zaldua\popbl\server2\server2-disk.vdi"


# SNAPSHOT
VBoxManage snapshot "server2" take "00_beforeInitialisation" --description="This is the virtual machine before starting it for the first time."


# RUN
VBoxManage startvm "server2"
```

# Client

```powershell title="client creation"
# MACHINE CONF
# client
VBoxManage createvm --name "client" --ostype "Windows11_64" --register --basefolder "C:\Users\xanet\VirtualBox VMs\Windows\xanet-zaldua" --groups "/popbl"
# ID / Description: Windows11_64 -- Windows 11 (64-bit)

# Basic conf
VBoxManage modifyvm "client" --memory 4096 --cpus 4

# NICs
VBoxManage modifyvm "client" --nic1 natnetwork --mac-address1 000102030413 --nat-network1 wpopblnetwork

# ISO controller
VBoxManage storagectl "client" --name "IDE" --add ide --controller PIIX4

# HDD controller
VBoxManage storagectl "client" --name "SATA" --add sata --controller IntelAhci --portcount 1  # we could use a higher port number to attach more than one disks

# ISO attach
VBoxManage storageattach "client" --storagectl "IDE" --port 0 --device 0 --type dvddrive --medium "C:\Users\xanet\Temp\26100.1742.240906-0331.ge_release_svc_refresh_CLIENTENTERPRISEEVAL_OEMRET_x64FRE_en-us.iso"

# Create medium
VBoxManage createmedium disk --filename "C:\Users\xanet\VirtualBox VMs\Windows\xanet-zaldua\popbl\client\client-disk" --size "120000" --format VDI
# HDD attach
VBoxManage storageattach "client" --storagectl "SATA" --port 0 --device 0 --type hdd --medium "C:\Users\xanet\VirtualBox VMs\Windows\xanet-zaldua\popbl\client\client-disk.vdi"


# SNAPSHOT
VBoxManage snapshot "client" take "00_beforeInitialisation" --description="This is the virtual machine before starting it for the first time."


# RUN
VBoxManage startvm "client"
```