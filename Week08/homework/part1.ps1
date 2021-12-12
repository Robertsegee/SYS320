# Storyline: Send an email.

# Variable can have an underscore or any alphanumeric value.

# Body of the email
$msg = "Hello there." 


#echoing to the screen
write-host -backgroundcolor Red -ForegroundColor White $msg

# Email from address
$email = "robert.segee@mymail.champlain.edu" 

# To address
$toemail = "deployer@csi-web"

# Sending the email
Send-MailMessage -From $email -To $toemail -Subject "A Greeting" -Body $msg -SmtpServer 192.168.6.71