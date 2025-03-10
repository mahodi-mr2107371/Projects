#!/bin/bash

# Function to create a user
create_user() {
  local username=$1
  local fullname=$2
  local pass=$3
  # Check if user already exists
  if id "$username" &>/dev/null; then
    echo "User $username already exists."
    exit 1
  fi

  # Create the user and set full name
  sudo useradd -m -c "$fullname" "$username"
  if [ $? -ne 0 ]; then
    echo "Error creating user $username"
    exit 1
  fi

  # feeding username and pass to change password of username to pass
  echo "$username:$pass" | sudo chpasswd
  echo "User $username created with password: $pass"
  echo "User $username created with password: $pass" >> ./server_output.log

  #checking if client group exists
  if ! getent group clients >/dev/null; then
    echo "Group 'clients' does not exist. Creating it now."
    sudo groupadd clients
  fi

  # Add the user to the clients and wheel groups
  sudo usermod -aG clients,wheel "$username"
  echo "User $username added to groups 'clients' and 'wheel'."
  sudo mkdir /home/$username/site
  sudo mkdir ~/../$username/site
  # Call the site configuration script for the new user
  ./server/scripts/config-site.sh
}

# Load clients from csv
exec < ./config/clients.csv
while read line; do
    PASS="$(./utils/generate-pass.sh)"
    # Extract the username from the line
    username=$(echo "$line" | cut -d',' -f1)
    fullname=$(echo "$line" | cut -d',' -f2)
    create_user $username "$fullname" $PASS
done
