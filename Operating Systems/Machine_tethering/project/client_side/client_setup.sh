#!/bin/bash
#Installing client requirements
sudo apt update
sudo apt install openssh-server
sudo systemctl start sshd
sudo systemctl enable sshd

#Checking SSH Status
#sudo systemctl status ssh
sudo systemctl is-enabled ssh


