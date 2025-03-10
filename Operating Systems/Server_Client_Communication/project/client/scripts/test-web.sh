#!/bin/sh
# Test web server accessibility
./utils/check-install.sh w3m w3m
./utils/check-install.sh curl curl
exec < ./config/server.csv
read line
ip=$(echo "$line" | cut -d"," -f5 | tr -d '[:space:]')
curl -I http://$ip:80
w3m http://$ip:80
