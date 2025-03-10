#!/bin/sh
# Setup public key authentication
exec < ./config/server.csv
read line
#serverip
ip=$(echo "$line" | cut -d"," -f5 | tr -d '[:space:]')

ssh-copy-id -i ~/.ssh/id_ed25519.pub $ip


