#!/bin/sh
# Publish site to server
exec < ./config/server.csv
read line
serverip=$(echo "$line" | cut -d"," -f5)
cd ~/site
hugo
rsync -avz public/ $serverip:/home/$(whoami)/site/






# Possible solution 


# #!/bin/sh
# # Publish site to server


# IFS=',' read -r field1 field2 field3 field4 serverip < ./config/server.csv

# if [ -z "$serverip" ]; then
#     echo "Error: server IP not found in the CSV file."
#     exit 1
# fi


# cd "/home/$(whoami)/team-calcium/projectPra/project/site" || { echo "Failed to change directory"; exit 1; }



# # Check if the Hugo configuration file exists
# if [ ! -f "config.toml" ]; then
#     echo "Error: Missing Hugo configuration file (config.toml)."
#     exit 1
# fi

# # Build the site
# hugo

# if [ ! -d "public" ]; then
#     echo "Error: 'public' directory does not exist."
#     exit 1
# fi


# rsync -avz public/ "$serverip:/home/$(whoami)/team-calcium/projectPra/project/site"
