#!/bin/bash

# Check if the script is run as root
if [[ $(id -u) -ne 0 ]]; then
	  echo "This script must be run as root."
	    exit 1
fi

# Check if database name argument is provided
if [[ -z "$1" ]]; then
	  echo "Please provide a database name as an argument."
	    exit 1
fi

# Generate a random password for the database user
PASSWORD=$(openssl rand -base64 12)

# Create database and grant privileges to user
mysql -e "CREATE DATABASE $1; \
	GRANT ALL PRIVILEGES ON $1.* TO '$1'@'localhost' IDENTIFIED BY '$PASSWORD';"

# Print database user password
echo "Database: $1"
echo "User: $1"
echo "Password: $PASSWORD"

# Store database name, user name and password in a file under /root
echo -e "Database: $1\nUser: $1\nPassword: $PASSWORD\n" >> /root/db_credentials.txt

# Restrict the permissions of the credentials file to root user only
chmod 600 /root/db_credentials.txt

