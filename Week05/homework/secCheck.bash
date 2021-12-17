#!/bin/bash 

#Script to perform local security checks

function checks(){

	if [[ $2 != $3 ]]
	then
		echo "The $1 is not compliant. The current policy should be: $2, the current value is: $3"
	else
		echo "The $1 policy is compliant, current value $3 "
	fi
}

# Check the password max days policy

pmax=$(egrep -i '^PASS_MAX_DAYS' /etc/login.defs | awk ' { print $2 } ')

#Check for password max

checks "Password Max Days" "365" "${pmax}"

# Checks the pass min days between changes
pmin=$(egrep -i '^PASS_MIN_DAYS' /etc/login.defs | awk ' { print $2 } ')
checks "Password Min Days" "14" "${pmin}"

#Check the pass warn age
pwarn=$(egrep -i '^PASS_WARN_AGE' /etc/login.defs | awk ' { print $2 } ')
checks "Password Warn Age" "7" "${pwarn}"

#Check the SSH UsePas config
chkSSHPAM=$(egrep -i "^UsePAM" /etc/ssh/sshd_config | awk ' { print $2 }' )
checks "SSH UsePAM" "yes" "${chkSSHPAM}"

#Checks perms on users home directory
echo ""
for eachDir in $(ls -l /home | egrep '^d' | awk ' { print $3 } ' )
do
	chDir=$(ls -ld /home/${eachDir} | awk ' { print $1 } ' )
	checks "Home Directory ${eachDir}" "drwx------" "${chDir}"
done

#Checks to see if ip forwarding is enabled
ipfwd=$(egrep -i "^net.ipv4.ip_forward" /etc/sysctl.conf | awk ' { print $2}' ) 
checks "IP Forwarding" "0" "${ipfwd}"
