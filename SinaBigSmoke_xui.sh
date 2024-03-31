#!/bin/bash

# Get Discord webhook URL from user and save it to a file
read -p "Please enter the Discord webhook URL: " WEBHOOK_URL
echo "$WEBHOOK_URL" > webhook_url.txt

# Get message from user and save it to a file
read -p "Please enter the message: " MESSAGE
echo "$MESSAGE" > message.txt

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
echo "$CRON_JOB /bin/bash /root/SinaBigSmoke_xui.sh" | sudo crontab -

# Read message from file
MESSAGE=$(cat message.txt)

# Read webhook URL from file
WEBHOOK_URL=$(cat webhook_url.txt)

# Send the file using curl with the saved message and webhook URL
curl -X POST -H "Content-Type: multipart/form-data" -F "content=$MESSAGE" -F "file=@$FILE_PATH" $WEBHOOK_URL

# Display success message
echo "Backup x-ui file sent successfully to Discord webhook. Coded By SinaBigSmoke <3"
