  #!/bin/sh
  # Configure client website directory
conf_site(){
  client_username=$1
  sudo ln -s /home/$client_username/site /usr/share/nginx/html/$client_username
  # Set permissions
  sudo setfacl -R -m u:nginx:r-x /home/$client_username
  sudo setfacl -R -m u:nginx:r-x /home/$client_username/site
}
exec < ./config/clients.csv
while read line;do
  username=$(echo "$line" | cut -d"," -f1)
  conf_site $username
done
