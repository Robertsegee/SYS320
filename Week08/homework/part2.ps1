# Storyline: Review the security event logs

#Directory to save files
$mydir = "C:\Users\Administrator\Desktop\"

# List all the available winodws event logs
Get-EventLog -list 

# Create a prompt to allow users to select the log to view
$readLog = Read-Host -Prompt "Please select a log to review from the list above"

# Create a prompt to read a string that users can search for
$readstring = Read-Host -Prompt "Please input a keyword that you would like to search"

# Print the results for the log
Get-EventLog -LogName $readLog -Newest 40 | where {$_.Message -ilike "*$readstring*" } | export-csv -NoTypeInformation -Path "$mydir\securitylogs.csv"
