#Storyline: View the event logs, check for a valid log, and print the results


function select_log() {

    cls

    #list all event logs
    $theLogs = Get-EventLog -list | select log
    $theLogs | Out-Host

    #Initialize the array to store the logs
    $arrLog = @()

    foreach ($tempLog in $theLogs) {
        
    
        # add each log to the array
        # note these are stored in the array as a hashtable in the format
        # @(Log=LOGNAME)
        $arrLog += $tempLog


    }

    $arrLog
    # Test to be sure our array is populated


    # prompt user for log to view or quit
    $readLog = read-host -Prompt "Please enter a log from the list above or 'q' to quit the program"


    # check to see if the user typed q
    if ($readLog -match "^[qQ]$") {
        #stop the program
        break


    }
    log_check -logToSearch $readLog

} #ends the select_log()


function log_check() {

    #string user types in within the select_log function
    Param([string]$logToSearch)

    #format the user's input 
    $theLog = "^@{Log=" + $logToSearch + "}$"

    #Searcg tge array fir tge exact hashtable string
    if ($arrLog -match $theLog) {

        Write-Host -BackgroundColor Green -ForegroundColor white "Please wait, it may take a few moments to retrieve the log entries."
        sleep 2

        #call the function to view the log
        view_log -logToSearch $logToSearch


    } else {
        Write-Host -BackgroundColor red -ForegroundColor white "the log specified does not exist."
        
    }



} #ends the log_check()

function view_log() {
    cls

    
    #get the logs
    Get-EventLog -LogName $logToSearch -Newest 10 -After "1/18/2020"

    #Pause the screen and wait until user is ready to proceed
    Read-Host -Prompt "Please enter when you are done."

    #go back to select log 
    select_log

} #ends the view_log()
 

 #plce holder, wihout it log will not show
 Get-EventLog -LogName Security -Newest 1
  #run the select_log as first function
 select_log
 
