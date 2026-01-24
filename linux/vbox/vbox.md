This folder will take notes about VBox configurations.

# Index
- [natnetwork](/linux/vbox/vboxManage/natnetwork.md)
- [showvminfo](/linux/vbox/vboxManage/showvminfo.md)
- [createvm](/linux/vbox/vboxManage/createvm.md)
	- [modifyvm](/linux/vbox/vboxManage/modifyvm.md)
- [createmedium](/linux/vbox/vboxManage/createmedium.md)
	- [showmediuminfo](/linux/vbox/vboxManage/showmediuminfo.md)
- [storagectl](/linux/vbox/vboxManage/storagectl.md)
	- [storageattach](/linux/vbox/vboxManage/storageattach.md)
- [snapshot](/linux/vbox/vboxManage/snapshot.md)
- [startvm](/linux/vbox/vboxManage/startvm.md)
- [clonevm](/linux/vbox/vboxManage/clonevm.md)

> Important
> Nat network won't work if we are using inet (internal net) interfaces

> Important!!!!!
> If you are having trouble with DHCP client refusing to take the leased IP, you probably have a vbox dhcp on!
> to fix this go see this file: [fix vbox dhcp](/linux/vbox/vboxManage/fixDhcp.md)

```powershell title="inet interface declaration"
vboxmanage modifyvm "zalduazerb1" --nic7 intnet --mac-address7 000102030107 --intnet7 zaldua1
```

We don't need to create a network, just declaring the inet name on --intnetN parameter is enough

I had DHCP enabled on the internal networks????

```powershell title="inet disable dhcp"
VBoxManage dhcpserver remove --netname zaldua1
VBoxManage dhcpserver remove --netname zaldua2
```