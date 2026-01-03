The VBoxManage createvm command creates a new XML virtual machine (VM) definition file.

```powershell title="VBox help"
VBoxManage createvm <--name=name> <--platform-architecture= x86 | arm> [--basefolder=basefolder] [--default] [--groups=group-ID [,...]] [--ostype=ostype] [--register]
      [--uuid=uuid] [--cipher=cipher] [--password-id=password-id] [--password=file]
```

## Example

```powershell
VBoxManage createvm --name "zaldua1zerb1" --ostype "Debian_64" --register --basefolder "C:\Users\xanet\VirtualBox VMs\Linux\xanet-zaldua" --groups "/eraikin-nagusia"
```

## Command Options

In addition to specifying the name or UUID of the VM and the platform architecture, which is required, you can specify any of the following options:

  --basefolder=<basefolder>
      Specifies the name of the folder in which to save the machine configuration file for the new VM.

      Note that the names of the file and the folder do not change if you rename the VM.

  --default
      Applies a default hardware configuration for the specified guest OS. By default, the VM is created with minimal hardware.

  --groups=<group-ID>[,...]
      Assigns the VM to the specified groups. If you specify more than one group, separate each group name with a comma.

      Note that each group is identified by a group ID that starts with a slash character (/) so that groups can be nested. By default, a VM is always assigned
      membership to the / group.

  --ostype=<ostype>
      Specifies the guest OS to run in the VM. Run the VBoxManage list ostypes command to see the available OS types.

  --register
      Registers the VM with your Oracle VirtualBox installation. By default, the VBoxManage createvm command creates only the XML configuration for the VM but does not
      register the VM. If you do not register the VM at creation, you can run the VBoxManage registervm command after you create the VM.

  --uuid=<uuid>
      Specifies the Universally Unique Identifier (UUID) of the VM. Ensure that this UUID is unique within the Oracle VirtualBox namespace of the host or of its VM group
      memberships if you decide to register the VM. By default, Oracle VirtualBox provides the UUID.

  --cipher=<cipher>
      Specifies the cipher to use for encryption. Valid values are AES-128 or AES-256.

      This option enables you to set up encryption on VM.

  --password-id=<password-id>
      Specifies a new password identifier that is used for correct identification when supplying multiple passwords for the VM.

      This option enables you to set up encryption on VM.

  --password=<file>
      Use the --password to supply the encryption password of the VM. Either specify the absolute pathname of a password file on the host operating system, or - to
      prompt you for the password on the command line.

      This option enables you to set up encryption on VM.