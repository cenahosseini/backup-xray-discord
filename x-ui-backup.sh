#!/bin/bash

# Define message to be sent along with the file
MESSAGE=""

# Get Discord webhook URL from user
read -p "Please enter the Discord webhook URL: " WEBHOOK_URL

# Get message from user
read -p "Please enter the message: " MESSAGE

# Install zip package
sudo apt update
sudo apt install zip -y

# Remove existing backup zip file
sudo rm -rf /root/SinaBigSmoke-x.zip

# Create a zip file containing specified files
sudo zip /root/SinaBigSmoke-x.zip /etc/x-ui/x-ui.db /usr/local/x-ui/config.json

# Add a comment to the zip file
echo -e "$MESSAGE" | sudo zip -z /root/SinaBigSmoke-x.zip

# Define path to the zip file
FILE_PATH="/root/SinaBigSmoke-x.zip"

# Add the cron job
echo "0 0 * * * /bin/bash /root/backup_script.sh" | sudo crontab -

# Send the file using curl
curl -X POST -H "Content-Type: multipart/form-data" -F "content=$MESSAGE" -F "file=@$FILE_PATH" $WEBHOOK_URL

# Display success message
echo "Backup file sent successfully to Discord webhook."
