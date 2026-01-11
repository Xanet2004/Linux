This document outlines the creation of Organizational Units (OUs) and users in the [proiektuak.edu] and [pbl.proiektuak.edu] domains.

# AD Structure

| OUs      | Users              | Emails                         |
| -------- | ------------------ | ------------------------------ |
| Teachers | Xabier Etxezarreta | xetxezarreta@proiektuak.edu    |
|          | Iñaki Garitano     | igaritano@proiektuak.edu       |
|          | TeacherTemplate    | teachertemplate@proiektuak.edu |
| Students | Xanet Zaldua       | xzaldua@proiektuak.edu         |
|          | Iraitz Maritxalar  | imaritxalar@proiektuak.edu     |
|          | StudentTemplate    | studenttemplate@proiektuak.edu |

# Create Organizational Units (OUs)

```powershell title="server1 - create OUs"
# Create OUs
New-ADOrganizationalUnit -Name "Teachers" -Path "DC=proiektuak,DC=edu"
New-ADOrganizationalUnit -Name "Students" -Path "DC=proiektuak,DC=edu"
```

# Create Template Users

Template users make it easier to replicate other users with the same settings (GUI “copy user” feature).

Is not necessary.

```powershell title="server1 - create template"
New-ADUser -Name "TeacherTemplate" `
           -SamAccountName "TeacherTemplate" `
           -UserPrincipalName "teachertemplate@proiektuak.edu" `
           -AccountPassword (ConvertTo-SecureString "123456789aA@" -AsPlainText -Force) `
           -Enabled $true `
           -Path "OU=Teachers,DC=proiektuak,DC=edu"

# Student template
New-ADUser -Name "StudentTemplate" `
           -SamAccountName "StudentTemplate" `
           -UserPrincipalName "studenttemplate@proiektuak.edu" `
           -AccountPassword (ConvertTo-SecureString "123456789aA@" -AsPlainText -Force) `
           -Enabled $true `
           -Path "OU=Students,DC=proiektuak,DC=edu"
```

# Create Users

We can create user in two ways:
1. Directly from the terminal.
2. Using a script to automate user creation.

## Creating Users from Terminal

```powershell title="server1 - create users"
# Teachers
New-ADUser -Name "Xabier Etxezarreta" -SamAccountName "xetxezarreta" `
  -UserPrincipalName "xetxezarreta@proiektuak.edu" `
  -AccountPassword (ConvertTo-SecureString "123456789aA@" -AsPlainText -Force) `
  -Enabled $true -Path "OU=Teachers,DC=proiektuak,DC=edu"

New-ADUser -Name "Iñaki Garitano" -SamAccountName "igaritano" `
  -UserPrincipalName "igaritano@proiektuak.edu" `
  -AccountPassword (ConvertTo-SecureString "123456789aA@" -AsPlainText -Force) `
  -Enabled $true -Path "OU=Teachers,DC=proiektuak,DC=edu"

# Students
New-ADUser -Name "Xanet Zaldua" -SamAccountName "xzaldua" `
  -UserPrincipalName "xzaldua@proiektuak.edu" `
  -AccountPassword (ConvertTo-SecureString "123456789aA@" -AsPlainText -Force) `
  -Enabled $true -Path "OU=Students,DC=proiektuak,DC=edu"

New-ADUser -Name "Iraitz Maritxalar" -SamAccountName "imaritxalar" `
  -UserPrincipalName "imaritxalar@proiektuak.edu" `
  -AccountPassword (ConvertTo-SecureString "123456789aA@" -AsPlainText -Force) `
  -Enabled $true -Path "OU=Students,DC=proiektuak,DC=edu"
```

## Creating Users from Script

```powershell title="server1 - create script folder and file"
# Create folder
New-Item -ItemType Directory -Path "C:\Users\Administrator\scripts\ad" -Force

# Create file
New-Item -ItemType File -Path "C:\Users\Administrator\scripts\ad\create-ad-users-from-template.ps1" -Force
```

### Editing script via GUI

```powershell title="server1 - open and edit script"
notepad.exe "C:\Users\Administrator\scripts\ad\create-ad-users-from-template.ps1"
```

> Script: [create-ad-users-from-template.ps1](/windows/services/activeDirectory/script/create-ad-users-from-template.ps1)

### Creating Script in local device

```powershell title="create file in the local device"
# Create folder
New-Item -ItemType Directory -Path "C:\Users\xanet\Temp\windows-server\scripts\ad" -Force

# Create script file
New-Item -ItemType File -Path "C:\Users\xanet\Temp\windows-server\scripts\ad\create-ad-users-from-template.ps1" -Force
```

```powershell title="open and edit script"
notepad.exe "C:\Users\xanet\Temp\windows-server\scripts\ad\create-ad-users-from-template.ps1"
```

> Script: [create-ad-users-from-template.ps1](/windows/services/activeDirectory/script/create-ad-users-from-template.ps1)

### Sending Script via SSH

```powershell title="copy file with ssh"
scp -P 1111 "C:\Users\xanet\Temp\windows-server\scripts\ad\create-ad-users-from-template.ps1" Administrator@localhost:C:\Users\Administrator\scripts\ad\
```

# Run Script

```powershell title="server1 - run script"
powershell -ExecutionPolicy Bypass -File "C:\Users\Administrator\scripts\ad\create-ad-users-from-template.ps1"
```

> 2
> Xabier Etxezarreta
> xetxezarreta (or just enter)
> xetxezarreta@proiektuak.edu (or just enter)
> 123456789aA@
> y
> Inaki Garitano
> igaritano (or just enter)
> igaritano@proiektuak.edu (or just enter)
> 123456789aA@
> n

> 3
> Xanet Zaldua
> xzaldua (or just enter)
> xzaldua@proiektuak.edu (or just enter)
> 123456789aA@
> y
> Iraitz Maritxalar
> imaritxalar (or just enter)
> imaritxalar@proiektuak.edu (or just enter)
> 123456789aA@
> n

# Test

```powershell title="server1 - list ous"
Get-ADOrganizationalUnit -Filter * | Select-Object Name
```

```powershell title="server1 - list users"
Get-ADUser -Filter * -Properties DistinguishedName | Select-Object Name, SamAccountName, DistinguishedName | Format-Table -AutoSize
```

```powershell title="server1 - delete ous"
# Remove-ADOrganizationalUnit -Identity "OU=Students,DC=proiektuak,DC=edu"
```

```powershell title="server1 - delete users"
# Remove-ADUser -Identity "xetxezarreta" -Confirm:$false
```

# Snapshot

```powershell title="stop computers"
Stop-Computer -Force
```

```powershell title="snapshots"
VBoxManage snapshot "server1" take "05_adUsersOUs" --description="This is the virtual machine after creating some OUs (Teachers, Students) and Users (xetxezarreta, igaritano, xzaldua, imaritxalar)."
```