#!/bin/sh
# Configure NGINX
./utils/check-install.sh nginx nginx
sudo systemctl enable nginx
sudo systemctl start nginx
sudo systemctl status nginx

# Add firewall rule for HTTP
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --reload

# Test NGINX
curl http://localhost
