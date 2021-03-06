#!/bin/bash

#Storyline: Extract the IPs from emergingthreats.net and create a firewall ruleset

#alert tcp [2.59.200.0/22,5.134.128.0/19,5.180.4.0/22,5.183.60.0/22,5.188.10.0/23,24.137.16.0/20,24.170.208.0/20,24.233.0.0/19,24.236.0.0/19,27.126.160.0/20,27.146.0.0/16,31.14.65.0/24,31.40.156.0/22,36.0.8.0/21,36.37.48.0/20,36.116.0.0/16,36.119.0.0/16,37.156.64.0/23,37.156.173.0/24,41.72.0.0/18] any -> $HOME_NET any (msg:"ET DROP Spamhaus DROP Listed Traffic Inbound group 1"; flags:S; reference:url,www.spamhaus.org/drop/drop.lasso; threshold: type limit, track by_src, seconds 3600, count 1; classtype:misc-attack; flowbits:set,ET.Evil; flowbits:set,ET.DROPIP; sid:2400000; rev:3027; metadata:affected_product Any, attack_target Any, deployment Perimeter, tag Dshield, signature_severity Minor, created_at 2010_12_30, updated_at 2021_09_29;)

# Regex to extract the networks
# 5.	134.	128.	0/	19
# wget http://rules.emergingthreats.net/blockrules/emerging-drop.suricata.rules -o /tmp/emerging-drop.suricata.rules

#Sort ips from file then put them into new file
egrep -o '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.0/[0-9]{1,2}' /tmp/emerging-drop.suricata.rules | sort -u | tee badIPs.txt

#Grep and seperate all lines with domains and put domains into a new txt file
grep "domain" targetedthreats.csv | cut -d "," -f 2 | tee -a  baddomains.txt

# Create a firewall ruleset
#for eachIP in $(cat badIPs.txt)
#do
	#echo "block in from ${eachIP} to any" | tee -a pf.conf

	#echo "iptables -A INPUT -s ${eachIP} -j DROP" | tee -a badIPs.iptables
#done




#Block menu funtion 
function blockmenu(){
	clear
	echo "[1] IPtables"
	echo "[2] Cisco"
	echo "[3] MAC OS X"
	read -p "Please enter a choice above: " choice

	case "$choice" in
		1)
			for eachIP in $(cat badIPs.txt)
			do
				echo "iptables -A INPUT -s ${eachIP} -j DROP" | tee -a badIPs.iptables
			done
		;;

		2) 
			echo "class-map match-any BAD_URLS"
			for eachdomain in $(cat baddomains.txt)
			do
				echo "match protocol http host ${eachdomain}" | tee -a baddomains.domains
			done
			;;
		3)
			for eachIP in $(cat badIPs.txt)
			do
		
				echo "block in from ${eachIP} to any" | tee -a pf.conf
			done	
				;;
	esac
		
		
		
}
blockmenu

