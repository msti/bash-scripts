#!/bin/bash

# Check if the script is run as root
if [[ $(id -u) -ne 0 ]]; then
	  echo "This script must be run as root."
	    exit 1
fi

# List all databases excluding system databases
echo "Available databases:"
mysql -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|performance_schema|mysql|sys)"

# Ask user if they want to delete a database
read -p "Enter the name of the database you want to delete (or 'n' to cancel): " DBNAME

if [[ "$DBNAME" == "n" ]]; then
	  echo "Database deletion cancelled."
	    exit 0
fi

# Prompt the user to confirm deletion
read -p "Delete database $DBNAME?  (y/n): " CONFIRM

if [[ "$CONFIRM" != "y" ]]; then
	  echo "Database deletion cancelled."
	    exit 0
fi

# Delete the database
mysql -e "DROP DATABASE $DBNAME;"
echo "$DBNAME database deleted successfully."

# Delete the associated user and their credentials from /root/db_credentials.txt
sed -i "/^Database: $DBNAME$/,/^$/d" /root/db_credentials.txt


