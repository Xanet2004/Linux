Steps to install virtual machines.
# Server 1

![[/windows/machineInstallation/server1/server1-installation-01.png]]
![[/windows/machineInstallation/server1/server1-installation-02.png]]
![[/windows/machineInstallation/server1/server1-installation-03.png]]
![[/windows/machineInstallation/server1/server1-installation-04.png]]
![[/windows/machineInstallation/server1/server1-installation-05.png]]
![[/windows/machineInstallation/server1/server1-installation-06.png]]
![[/windows/machineInstallation/server1/server1-installation-07.png]]
![[/windows/machineInstallation/server1/server1-installation-08.png]]
![[/windows/machineInstallation/server1/server1-installation-10.png]]
![[/windows/machineInstallation/server1/server1-installation-011.png]]
![[/windows/machineInstallation/server1/server1-installation-11.png]]
# Server 2

> Same steps as server1

# Client

> Same steps as server1 until...

![[/windows/machineInstallation/client/client-installation-01.png]]
![[/windows/machineInstallation/client/client-installation-02.png]]
![[/windows/machineInstallation/client/client-installation-03.png]]
![[/windows/machineInstallation/client/client-installation-04.png]]
![[/windows/machineInstallation/client/client-installation-05.png]]
![[/windows/machineInstallation/client/client-installation-06.png]]
![[/windows/machineInstallation/client/client-installation-07.png]]
![[/windows/machineInstallation/client/client-installation-08.png]]
![[/windows/machineInstallation/client/client-installation-09.png]]
![[/windows/machineInstallation/client/client-installation-10.png]]
![[/windows/machineInstallation/client/client-installation-11.png]]
![[/windows/machineInstallation/client/client-installation-12.png]]
![[/windows/machineInstallation/client/client-installation-13.png]]
![[/windows/machineInstallation/client/client-installation-14.png]]
![[/windows/machineInstallation/client/client-installation-15.png]]
![[/windows/machineInstallation/client/client-installation-16.png]]
# After installation

Once the machines are installed, we are going to take off the iso disks from the machines.
This way we are not reinstalling every time we turn on the machines.

Turn off the machines and change order and disable Floppy and Optical devices.

![[/windows/machineInstallation/server1/server1-installation-after.png]]

```powershell title="snapshot after installations"
VBoxManage snapshot "server1" take "01_installed" --description="This is the virtual machine after the installation."

VBoxManage snapshot "server2" take "01_installed" --description="This is the virtual machine after the installation."

VBoxManage snapshot "client" take "01_installed" --description="This is the virtual machine after the installation."
```