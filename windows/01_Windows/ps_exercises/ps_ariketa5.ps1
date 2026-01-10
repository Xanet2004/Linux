Write-Output "Sistemako informazioa bilatzen..."

$os = (Get-CimInstance Win32_OperatingSystem).Caption

Write-Output "Sistema Eragilea: $os"

$fecha = Get-Date -Format "MM/dd/yyyy HH:mm:ss"
Write-Output "Data eta ordua gaur: $fecha"
