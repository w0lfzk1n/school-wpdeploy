#!/bin/bash

# === CONFIGURABLE VARIABLES ===
DB_NAME="wordpress_db"
DB_USER="wp_user"
DB_PASS="wp_pass123"
DB_HOST="192.168.60.10"  # IP of the DB Server
WP_DIR="/var/www/html"

# === Helper function for clear step output ===
print_step() {
    echo ""
    echo "------------------------------------------------------------"
    echo "[+] $1"
    echo "------------------------------------------------------------"
    echo ""
}

print_step "Updating system packages..."
apt update && apt upgrade -y

print_step "Installing Apache, PHP, and required extensions..."
apt install apache2 php php-mysql libapache2-mod-php php-cli php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip unzip ufw -y

print_step "Enabling Apache mod_rewrite..."
a2enmod rewrite

print_step "Configuring Apache to allow .htaccess overrides..."
APACHE_CONF="/etc/apache2/sites-available/000-default.conf"
if ! grep -q "<Directory ${WP_DIR}>" $APACHE_CONF; then
    sed -i "/<\/VirtualHost>/i <Directory ${WP_DIR}>\n    AllowOverride All\n</Directory>" $APACHE_CONF
else
    sed -i "/<Directory ${WP_DIR}>/,/<\/Directory>/ s/AllowOverride .*/AllowOverride All/" $APACHE_CONF
fi

print_step "Restarting Apache to apply changes..."
systemctl restart apache2
systemctl enable apache2

print_step "Downloading and installing WordPress..."
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
rm latest.tar.gz
rm -f ${WP_DIR}/index.html
cp -r wordpress/* ${WP_DIR}
rm -rf wordpress

print_step "Setting permissions for WordPress..."
chown -R www-data:www-data ${WP_DIR}
chmod -R 755 ${WP_DIR}

print_step "Creating wp-config.php..."
cp ${WP_DIR}/wp-config-sample.php ${WP_DIR}/wp-config.php
sed -i "s/database_name_here/${DB_NAME}/" ${WP_DIR}/wp-config.php
sed -i "s/username_here/${DB_USER}/" ${WP_DIR}/wp-config.php
sed -i "s/password_here/${DB_PASS}/" ${WP_DIR}/wp-config.php
sed -i "s/localhost/${DB_HOST}/" ${WP_DIR}/wp-config.php

print_step "Application server setup complete (LOCAL USE ONLY)."
echo "Visit http://${APP_SERVER_IP} to complete WordPress installation."
