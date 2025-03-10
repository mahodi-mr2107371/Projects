#!/bin/bash
# Identify current client by matching IP or hostname
current_ip=$(ip addr show | grep 'inet ' | grep -v '127.0.0.1' | awk '{print $2}' | cut -d'/' -f1 | head -n1)
client_info=$(grep "$current_ip" ./config/clients.csv)

# Extract client details
username=$(echo $client_info | cut -d',' -f1)
fullname=$(echo $client_info | cut -d',' -f2)
email=$(echo $client_info | cut -d',' -f3)
hostname=$(echo $client_info | cut -d',' -f4)
client_ip=$(echo $client_info | cut -d',' -f5)

# Set hostname
sudo hostnamectl set-hostname $hostname
passphrase=$(./utils/generate-pass.sh)
# Calling client scripts
echo "running create-keys.sh"
./client/scripts/create-keys.sh
echo "running setup-auth.sh"
./client/scripts/setup-auth.sh
echo "running test-remote.sh"
./client/scripts/test-remote.sh
echo "running exec-map.sh"
./client/scripts/exec-map.sh
echo "running test-web.sh"
./client/scripts/test-web.sh
echo "running init-site.sh"
./client/scripts/init-site.sh
echo "running publish-site.sh"
./client/scripts/publish-site.sh

# Display system information
echo "running fetch-info.sh"
./utils/fetch-info.sh
