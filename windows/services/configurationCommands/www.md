WWW commands

# Installation

```powershell title="installation"
Install-WindowsFeature -name Web-Server -IncludeManagementTools

# Verify
Get-WindowsFeature Web-Server
```

## Add Show and Delete a web page

```powershell title="ad forest"
# List websites 
Get-Website 

# Create a website 
New-IISSite -Name "hello_world" -PhysicalPath "C:\Sites\HelloWorld" -BindingInformation "*:80:www.enpresa.eus" 

# Deleting a Website 
Remove-Website -Name "hello_world"
```

## HTTPS Certificate

[WWW](/windows/services/configurationCommands/www.pdf)
