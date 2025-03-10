sudo apt update
sudo apt upgrade

#setting up SSH for server
sudo apt install openssh-server

sudo systemctl enable sshd
sudo nano /etc/ssh/sshd_config

#Match Group sftpgroup
#ChrootDirectory %h
#X11Forwarding no
#AllowTcpForwarding no
#ForceCommand internal-sftp


#setting up SFTP server

$ sudo groupadd sftpgroup

$ sudo useradd sftp_server

$ sudo usermod -a -G sftp sftp_server

$ sudo mkdir -p /var/sftp/Files

$ sudo chown root:root /var/sftp

$ sudo chmod 755 /var/sftp

#Match User sftp_server
#ChrootDirectory /var/sftp
#X11Forwarding no
#AllowTcpForwarding no
#ForceCommand internal-sftp


sudo systemctl restart ssh


