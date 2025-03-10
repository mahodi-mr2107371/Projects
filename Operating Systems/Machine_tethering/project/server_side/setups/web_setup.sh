#installing apache
sudo apt update # to update all files
sudo apt install apache2 # to install
sudo systemctl start apache2  #to start the server

#ip a :to check local ip address. We need this to so that we can use the address on the browser to access the website

#adding authentication for accessing the web site:
#STEP 1: Setup Basic HTTP Authentication credentials.

#First we have to verify that apache2-utils package is installed, if not run:
sudo apt-get install apache2-utils

#We use a utility called “htpasswd” to create a file that will contain user and password which will be used to access restricted content.
sudo htpasswd -c /etc/apache2/.htpasswd admin # username : admin
#You’ll be asked to supply and confirm a password for user 

#**If you would like to add additional users to the htpasswd file, remove the "-c" command flag so you don't overwrite the htpasswd file.**

#STEP 2: Configure Apache Password Authentication

#Configure HTTP Authentication with .htaccess file.**

#To setup password authentication with .htaccess file instead, you will need to edit main Apache main configuration to allow .htaccess file.

# Modify the, block from **None** to **All**
sudo subl /etc/apache2/apache2.conf

#_<Directory /var/www/>  
#Options Indexes FollowSymLinks  
#AllowOverride All  
#Require all granted  
#</Directory>

#Next, we need to add an .htaccess file to the directory we wish to restrict as shown below.

sudo subl /var/www/html/.htaccess

#AuthType Basic  
#AuthName "Restricted Content"  
#AuthUserFile /etc/apache2/.htpasswd  
#Require valid-user

#Save and close the file when you are finished. Test and Restart/Reload Apache to implement your password policy:

sudo apachectl -t

sudo systemctl restart apache2
