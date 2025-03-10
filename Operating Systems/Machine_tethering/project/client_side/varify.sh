#!/bin/bash
# Create a user named "techuser" with a password.
echo "Trying to add techuser using sudo"
sudo useradd -m techuser
echo "Enter password for techuser:"
sudo passwd techuser

echo "techuser ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers

# Attempt running main.sh under "techuser".
echo "Attempting to run main.sh under techuser..."
if sudo -u techuser ./main.sh; then
	exit 0
else

	# Create a new group named "admins".
	sudo groupadd admins
	# Add "admins" to the sudoers file (/etc/sudoers).
	sudo bash -c 'echo "%admins ALL=(ALL:ALL) ALL" >> /etc/sudoers'

	# Include "techuser" in the "admins" group.
	sudo usermod -aG admins techuser

	# Try executing main.sh again as "techuser".
	echo "Attempting to run main.sh again as techuser..."
	sudo -u techuser ./main.sh


fi
