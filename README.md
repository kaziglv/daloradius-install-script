# daloRADIUS Installation Script

This repository contains a script to install daloRADIUS on an Ubuntu 22.04 server. daloRADIUS is an advanced web application for managing FreeRADIUS deployments.

## How to Use This Script

Follow the steps below to use this script for installing daloRADIUS on your Ubuntu 22.04 server.

### Step 1: Download the Script

1. SSH into your Ubuntu server.
2. Use `wget` to download the script from this repository:

```bash
wget https://raw.githubusercontent.com/<your-username>/daloradius-install-script/main/install_daloradius.sh


Step 2: Make the Script Executable
Change the permissions of the downloaded script to make it executable:

Step 3: Run the Script
Execute the script with superuser privileges:
sudo ./install_daloradius.sh

Script Details
The script performs the following actions:

Updates and upgrades the system.
Installs Apache2, MySQL server, PHP, and required PHP extensions.
Installs FreeRADIUS and required modules.
Downloads and installs daloRADIUS.
Configures MySQL for FreeRADIUS and daloRADIUS.
Configures FreeRADIUS to use MySQL.
Sets appropriate permissions for daloRADIUS.
Restarts Apache and FreeRADIUS services.
Accessing daloRADIUS
After the installation is complete, you can access the daloRADIUS web interface at:


http://<your-server-ip>/daloradius


Replace <your-server-ip> with the actual IP address of your server.

Contributions
Feel free to open issues or submit pull requests if you find any bugs or have suggestions for improvements.
