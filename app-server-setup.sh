#!/bin/bash

# === CONFIGURABLE VARIABLES ===
DB_NAME="wordpress_db"
DB_USER="wp_user"
DB_PASS="wp_pass123"
APP_SERVER_IP="192.168.203.128"  # IP of the App Server
DB_HOST="192.168.203.129"  # IP of the DB Server
WP_DIR="/var/www/html"

# Confirm with the user, that the IP addresses are correct and not from tetsing environment
echo ""
echo "------------------------------------------------------------"
echo "[!] Please confirm the following configuration:"
echo "Database Name: ${DB_NAME}"
echo "Database User: ${DB_USER}"
echo "Database Password: ${DB_PASS}"
echo "App Server IP: ${APP_SERVER_IP}"
echo "DB Server IP: ${DB_HOST}"
echo "------------------------------------------------------------"
read -p "Is this correct? (yes/no): " confirm
if [[ "$confirm" != "yes" ]]; then
    echo "Exiting setup. Please check your configuration."
    exit 1
fi

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
apt install apache2 php php-mysql libapache2-mod-php php-cli php-curl php-gd php-mbstring php-xml php-xmlrpc php-soap php-intl php-zip unzip -y

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
