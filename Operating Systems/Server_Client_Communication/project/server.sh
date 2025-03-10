#!/bin/sh
# Read from config/server.csv
while IFS=',' read -r username fullname email hostname ipaddress; do
    sudo hostnamectl set-hostname $hostname
    echo "runnning config-sshd.sh"
    ./server/scripts/config-sshd.sh
    echo "runnning config-mosh.sh"
    ./server/scripts/config-mosh.sh
    echo "runnning config-nginx.sh"
    ./server/scripts/config-nginx.sh
    echo "runnning create-client.sh"
    ./server/scripts/create-client.sh
    echo "runnning config-site.sh"
    ./server/scripts/config-site.sh
done < config/server.csv
# Fetch system info
echo "runnning fetch-info.sh"
./utils/fetch-info.sh
