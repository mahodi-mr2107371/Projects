#!/bin/bash

# Install OpenSSH server if not already installed
./utils/check-install.sh sshd openssh-server

# Enable and start the SSH service
sudo systemctl enable sshd
sudo systemctl start sshd
sudo systemctl status sshd

# Configure SSH to allow only clients group access
echo "AllowGroups clients" | sudo tee -a /etc/ssh/sshd_config

# Enable SFTP access
echo "Subsystem sftp /usr/libexec/openssh/sftp-server" | sudo tee -a /etc/ssh/sshd_config

# Restart SSH service
sudo systemctl restart sshd
echo "SSH server configured and restarted."
