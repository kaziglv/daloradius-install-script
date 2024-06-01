#!/bin/bash

# Update and upgrade the system
sudo apt update
sudo apt upgrade -y

# Install Apache2
sudo apt install apache2 -y

# Install MySQL server
sudo apt install mysql-server -y

# Secure MySQL installation (you will be prompted to set root password and other security settings)
sudo mysql_secure_installation

# Install PHP and required extensions
sudo apt install php libapache2-mod-php php-mysql php-cli php-curl php-xml php-mbstring php-pear php-gd -y

# Install FreeRADIUS and required modules
sudo apt install freeradius freeradius-mysql freeradius-utils -y

# Download daloRADIUS
cd /var/www/html
sudo wget https://github.com/lirantal/daloradius/archive/refs/tags/1.3.tar.gz

# Install tar if not installed
sudo apt install tar -y

# Extract daloRADIUS
sudo tar -zxvf 1.3.tar.gz
sudo mv daloradius-1.3 daloradius
sudo rm 1.3.tar.gz

# Set ownership and permissions
sudo chown -R www-data:www-data /var/www/html/daloradius
sudo chmod -R 755 /var/www/html/daloradius

# Configure MySQL database for FreeRADIUS
sudo mysql -u root -p -e "CREATE DATABASE radius;"
sudo mysql -u root -p -e "CREATE USER 'radius'@'localhost' IDENTIFIED BY 'radiuspassword';"
sudo mysql -u root -p -e "GRANT ALL PRIVILEGES ON radius.* TO 'radius'@'localhost';"
sudo mysql -u root -p -e "FLUSH PRIVILEGES;"
sudo mysql -u root -p radius < /etc/freeradius/3.0/mods-config/sql/main/mysql/schema.sql

# Configure FreeRADIUS to use MySQL
sudo ln -s /etc/freeradius/3.0/mods-available/sql /etc/freeradius/3.0/mods-enabled/
sudo sed -i 's|driver = "rlm_sql_null"|driver = "rlm_sql_mysql"|' /etc/freeradius/3.0/mods-available/sql
sudo sed -i 's|dialect = "sqlite"|dialect = "mysql"|' /etc/freeradius/3.0/mods-available/sql
sudo sed -i 's|#.*server = "localhost"|server = "localhost"|' /etc/freeradius/3.0/mods-available/sql
sudo sed -i 's|#.*port = 3306|port = 3306|' /etc/freeradius/3.0/mods-available/sql
sudo sed -i 's|#.*login = "radius"|login = "radius"|' /etc/freeradius/3.0/mods-available/sql
sudo sed -i 's|#.*password = "radpass"|password = "radiuspassword"|' /etc/freeradius/3.0/mods-available/sql
sudo sed -i 's|#.*radius_db = "radius"|radius_db = "radius"|' /etc/freeradius/3.0/mods-available/sql

# Restart FreeRADIUS
sudo systemctl restart freeradius

# Configure daloRADIUS database
sudo mysql -u root -p radius < /var/www/html/daloradius/contrib/db/fr2-mysql-daloradius-and-freeradius.sql

# Configure daloRADIUS
sudo cp /var/www/html/daloradius/library/daloradius.conf.php.sample /var/www/html/daloradius/library/daloradius.conf.php
sudo sed -i 's|$configValues\['CONFIG_DB_HOST'\] = '\''localhost'\'';|$configValues['CONFIG_DB_HOST'] = '\''localhost'\'';|' /var/www/html/daloradius/library/daloradius.conf.php
sudo sed -i 's|$configValues\['CONFIG_DB_USER'\] = '\''root'\'';|$configValues['CONFIG_DB_USER'] = '\''radius'\'';|' /var/www/html/daloradius/library/daloradius.conf.php
sudo sed -i 's|$configValues\['CONFIG_DB_PASS'\] = '\''radpass'\'';|$configValues['CONFIG_DB_PASS'] = '\''radiuspassword'\'';|' /var/www/html/daloradius/library/daloradius.conf.php
sudo sed -i 's|$configValues\['CONFIG_DB_NAME'\] = '\''radius'\'';|$configValues['CONFIG_DB_NAME'] = '\''radius'\'';|' /var/www/html/daloradius/library/daloradius.conf.php

# Restart Apache
sudo systemctl restart apache2

echo "daloRADIUS installation and configuration completed."
echo "You can now access daloRADIUS at http://<your-server-ip>/daloradius"
