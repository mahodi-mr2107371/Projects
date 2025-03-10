#!/bin/sh

# Check and install SSH client
./utils/check-install.sh ssh openssh-clients

# Check and install Mosh
./utils/check-install.sh mosh mosh

# loading server IP from config/server.csv
exec < ./config/server.csv
read server
ip=$(echo "$server" | cut -d"," -f5 | tr -d '[:space:]')

exec < ./config/clients.csv
read client
username=$(echo "$client" | cut -d"," -f1)

# Test SSH connectivity
echo "Testing SSH connecrion to $username@$ip"
status=$(ssh -o BatchMode=yes -o ConnectTimeout=5 $username@$ip echo ok 2>&1)

if [[ $status == ok ]] ; then
  echo "SSH connect is on with $username@$ip"
elif [[ $status == "Permission denied"* ]] ; then
  echo "SSH connection was denied with $username@$ip"
else
  echo "SSH connection error"
fi

# Test Mosh connectivity
echo "Testing Mosh connection to $username@$ip..."
mosh_status=$(mosh $username@$ip --ssh="ssh -o BatchMode=yes" --no-init 2>&1)

if echo "$mosh_status" | grep -q "MOSH CONNECT"; then
  echo "Mosh connection is successful with $username@$ip"
else
  echo "Mosh connection error: $mosh_status"
  echo "Ensure Mosh is installed on the server and UDP ports are open."
fi
