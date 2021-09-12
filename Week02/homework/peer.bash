#!/bin/bash

#Storyline: Create peer VPN config file



# What is peer name
echo -n "What is the peer's name? "
read the_client

#filename variable
pFile="${the_client}-wg0.conf"

echo "${pFile}"
# check if peer file exists
if [[ -f "${pFile}" ]]
then
	#prompt if we need to overwrite the file
	echo "The file ${pFile} exists."
	echo -n "Do you want to overwrite it? [y|n]"
	read to_overwrite
	
	if [[ "${to_overwrite}" == "n" || "${to_overwrite}" == "" ]]
	then
		echo "Exit..."
		exit 0
	elif [[ "${to_overwrite}" == "y" ]]
	then
		echo "Creating the wireguard configuration file..."
	else
		echo "Invalid value"
		exit 1

	fi


fi

# Generate private key
p="$(wg genkey)"

# Generate public key
clientpub="$(echo ${p} | wg pubkey)"

# Generate a preshared key
pre="$(wg genpsk)"

# Endpoint
end="$(head -1 /etc/wireguard/wg0.conf | awk ' {print $3 } ')"

# Server Public key
pub="$(head -1 /etc/wireguard/wg0.conf | awk ' {print $4 } ')"

# DNS servers
dns="$(head -1 /etc/wireguard/wg0.conf | awk ' {print $5 } ')"

# MTU
mtu="$(head -1 /etc/wireguard/wg0.conf | awk ' {print $6 } ')"

# KeepAlive
keep="$(head -1 /etc/wireguard/wg0.conf | awk ' {print $7 } ')"

#Default routes for VPN
routes="$(head -1 /etc/wireguard/wg0.conf | awk ' {print $8 } ')"

# Listening port
lport="$(shuf -n1 -i 40000-50000)"

# Create client configuration file

echo "[Interface]
Address = 10.254.132.100/24
DNS = ${dns}
Listenport = ${lport}
MTU = ${mtu}
PrivateKey = ${p}

[Peer]
AllowedIPs = ${routes}
PersistantKeepAlive = ${keep}
PresharedKey = ${pre}
PrivateKey = ${pub}
Endpoint = ${end}

" > ${pFile}

# Add peer configuration to the server config
echo "
[Peer]
Public Key = ${clientpub}
PresharedKey = ${pre}
AllowedIPs = 10.254.132.100/32

" | tee -a /etc/wireguard/wg0.conf




