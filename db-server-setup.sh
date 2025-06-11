#!/bin/bash

# === CONFIGURABLE VARIABLES ===
DB_NAME="wordpress_db"
DB_USER="wp_user"
DB_PASS="wp_pass123"
DB_ROOT_PASS="root_pass123"
APP_SERVER_IP="192.168.203.128"  # IP of the App Server

# Confirm with the user, that the IP addresses are correct and not from tetsing environment
echo ""
echo "------------------------------------------------------------"
echo "[!] Please confirm the following configuration:"
echo "Database Name: ${DB_NAME}"
echo "Database User: ${DB_USER}"
echo "Database Password: ${DB_PASS}"
echo "App Server IP: ${APP_SERVER_IP}"
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

print_step "Installing MariaDB..."
apt install mariadb-server ufw -y

print_step "Securing MariaDB..."
sudo mysql <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASS}';
DELETE FROM mysql.user WHERE User='';
DROP DATABASE IF EXISTS test;
FLUSH PRIVILEGES;
EOF

print_step "Creating database and user for WordPress..."
mysql -u root -p${DB_ROOT_PASS} -e "CREATE DATABASE ${DB_NAME} DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
mysql -u root -p${DB_ROOT_PASS} -e "CREATE USER '${DB_USER}'@'${APP_SERVER_IP}' IDENTIFIED BY '${DB_PASS}';"
mysql -u root -p${DB_ROOT_PASS} -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'${APP_SERVER_IP}';"
mysql -u root -p${DB_ROOT_PASS} -e "FLUSH PRIVILEGES;"

print_step "Configuring MariaDB to listen on all interfaces..."
sed -i "s/^bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf

print_step "Restarting and enabling MariaDB..."
systemctl restart mariadb
systemctl enable mariadb

print_step "Database server setup complete (LOCAL USE ONLY)."
