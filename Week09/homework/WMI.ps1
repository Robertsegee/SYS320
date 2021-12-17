# Use the Get-WMI cmdlet 
#Get-WmiObject -Class Win32_service | select Name, PathName, ProcessId

#Get-WmiObject -list | where { $_.Name -ilike "Win32_[n-o]*" } | Sort-Object

#Get-WmiObject -Class Win32_account | Get-Member

#task: Grab the network adapter information using the wmi class
#Get the ip address, default gateway, and the dns server

Get-CimInstance Win32_NetworkAdapterConfiguration -Filter "DHCPEnabled=$true" | Select DHCPServer



#Normally this would work however calculator is not installed on this box
Start-Process -FilePath calc.exe
Start-Sleep -Seconds 3
Get-Process -Name Calculator | Stop-Process

