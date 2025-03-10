#!/bin/sh
./utils/check-install.sh nmap nmap
interface=$(ip route | awk '/default/ {print $5}')
network=$(ip addr show $interface | awk '/inet / {print $2}' | cut -d/ -f1 | awk -F. '{print $1"."$2"."$3".0/24"}')
nmap -sn $network
