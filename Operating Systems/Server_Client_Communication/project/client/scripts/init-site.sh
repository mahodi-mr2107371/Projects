#!/bin/sh
# Initialize Hugo site without using Git
./utils/check-install.sh hugo hugo

# Create a new Hugo site
hugo new site site
cd site

# Download and extract a Hugo theme (e.g., Ananke theme)
theme_url="https://github.com/theNewDynamic/gohugo-theme-ananke/archive/master.zip"
theme_name="ananke"

# Download the theme
curl -L $theme_url -o $theme_name.zip

# Extract the theme
unzip $theme_name.zip -d themes/
mv themes/gohugo-theme-ananke-master themes/$theme_name

# remove up the ZIP file
rm $theme_name.zip

# Configure the theme in config.toml
echo 'theme = "ananke"' >> config.toml

# Create a sample content file
hugo new posts/my-first-post.md

