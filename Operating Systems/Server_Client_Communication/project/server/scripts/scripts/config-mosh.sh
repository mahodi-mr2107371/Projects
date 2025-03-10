#!/bin/sh
# Configure Mosh
./utils/check-install.sh mosh mosh
sudo cp ./server/config/mosh.xml /etc/firewalld/services/
sudo firewall-cmd --permanent --add-service=mosh
sudo firewall-cmd --reload
