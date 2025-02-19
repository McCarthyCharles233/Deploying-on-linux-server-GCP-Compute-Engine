#!/bin/bash

# Update system packages
sudo apt update
sudo apt upgrade -y

# Install Nginx
sudo apt install nginx -y

# Start Nginx and enable it to run on boot
sudo systemctl start nginx
sudo systemctl enable nginx

# Allow HTTP traffic through firewall
sudo apt install ufw -y
sudo ufw allow 'Nginx HTTP'
sudo ufw allow OpenSSH
sudo ufw --force enable

# Create a directory for your website
sudo mkdir -p /var/www/html
sudo chown -R $USER:$USER /var/www/html

# Create a simple Nginx configuration
sudo bash -c 'cat > /etc/nginx/sites-available/default << EOL
server {
    listen 80 default_server;
    listen [::]:80 default_server;
    
    root /var/www/html;
    index index.html;
    
    location / {
        try_files \$uri \$uri/ =404;
    }
}
EOL'

# Reload Nginx to apply changes
sudo systemctl reload nginx
