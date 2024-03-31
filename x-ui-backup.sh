#!/bin/bash

# Function to display error messages
display_error() {
    echo "Error: $1"
    exit 1
}

# Get Discord webhook URL from user
read -p "Please enter the Discord webhook URL: " WEBHOOK_URL
[[ -z "$WEBHOOK_URL" ]] && display_error "Discord webhook URL cannot be empty."

# Get message from user
read -p "Please enter the message: " MESSAGE

# Remove existing backup zip file
rm -rf /root/SinaBigSmoke-x.zip

# Create a zip file containing specified files
zip /root/SinaBigSmoke-x.zip /etc/x-ui/x-ui.db /usr/local/x-ui/config.json || display_error "Failed to create backup zip file."

# Add a comment to the zip file
echo -e "$MESSAGE" | zip -z /root/SinaBigSmoke-x.zip || display_error "Failed to add comment to backup zip file."

# Define path to the zip file
FILE_PATH="/root/SinaBigSmoke-x.zip"

# Add the cron job
(crontab -l 2>/dev/null; echo "0 0 * * * /bin/bash /root/backup_script.sh") | crontab - || display_error "Failed to add cron job."

# Send the file using curl
curl_output=$(curl -s -X POST -H "Content-Type: multipart/form-data" -F "content=$MESSAGE" -F "file=@$FILE_PATH" "$WEBHOOK_URL")
[[ "$curl_output" != "ok" ]] && display_error "Failed to send backup file to Discord webhook."

# Display success message
echo "Backup file sent successfully to Discord webhook."
