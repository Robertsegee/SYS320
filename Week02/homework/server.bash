#!/bin/bash

# Storyline: Scrip to create a wireguard server

#create a private key
p="$(wg genkey)"

#Create pub key
pub="$(echo ${p} | wg pubkey)"

#Set the addresses
address="10.254.132.0/24,172.16.28.0/24"

# Set Server Ip addresses
ServerAddress="10.254.132.1/24,172.16.28.1/24"

#Set listening port
lport="4282"

#Create the format for the client config option
peerInfo="# ${address} 192.168.7.61:4282 ${pub} 8.8.8.8,1.1.1.1 1280 120 0.0.0.0/0"


echo "${peerInfo}
[Interface]
Address = ${ServerAddress}
#Postup = /etc/wireguard/wg-up.bash
#Postdown = /etc/wireguard/wg-down.bash
Listenport = ${lport}
Privatekey = ${p}
" > wg0.conf
