#!/bin/bash

# Define message to be sent along with the file
MESSAGE=""

# Get Discord webhook URL from user
read -p "Please enter the Discord webhook URL: " WEBHOOK_URL

# Get message from user
read -p "Please enter the message: " MESSAGE

# Get cron job from user
read -p "Please enter the cron job schedule (e.g., '0 0 * * *' for daily at midnight): " CRON_JOB

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

# Display current system time
echo "Current system time:"
date

# Display chosen cron job
echo "Chosen cron job schedule:"
echo "$CRON_JOB"

# Get and display cron jobs
echo "Cron jobs:"
sudo crontab -l

# Add the cron job
echo "$CRON_JOB /bin/bash /root/SinaBigSmoke_backupx.sh" | sudo crontab -

# Send the file using curl
curl -X POST -H "Content-Type: multipart/form-data" -F "content=$MESSAGE" -F "file=@$FILE_PATH" $WEBHOOK_URL

# Display success message
echo "Backup x-ui file sent successfully to Discord webhook. Coded By SinaBigSmoke <3"