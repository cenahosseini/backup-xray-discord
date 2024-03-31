#!/bin/bash

# Define file paths for configuration
CONFIG_FILE_WEBHOOK="webhook.txt"
CONFIG_FILE_MESSAGE="message.txt"
CONFIG_FILE_CRON="cron.txt"

# Function to get input from user and save it to config file
get_input_and_save() {
    read -p "$1" INPUT
    echo "$INPUT" > "$2"
}

# Function to read input from config file
read_input_from_config() {
    INPUT=$(cat "$1")
}

# Check if config files exist
if [ ! -f "$CONFIG_FILE_WEBHOOK" ] || [ ! -f "$CONFIG_FILE_MESSAGE" ] || [ ! -f "$CONFIG_FILE_CRON" ]; then
    # If config files do not exist, get input from user and save them to config files
    get_input_and_save "Please enter the Discord webhook URL: " "$CONFIG_FILE_WEBHOOK"
    get_input_and_save "Please enter the message: " "$CONFIG_FILE_MESSAGE"
    get_input_and_save "Please enter the cron job schedule (e.g., '0 0 * * *' for daily at midnight): " "$CONFIG_FILE_CRON"
fi

# Read input from config files
read_input_from_config "$CONFIG_FILE_WEBHOOK"
WEBHOOK_URL="$INPUT"

read_input_from_config "$CONFIG_FILE_MESSAGE"
MESSAGE="$INPUT"

read_input_from_config "$CONFIG_FILE_CRON"
CRON_JOB="$INPUT"

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

# Send the file using curl with the saved message and webhook URL
curl -X POST -H "Content-Type: multipart/form-data" -F "content=$MESSAGE" -F "file=@$FILE_PATH" $WEBHOOK_URL

# Display success message
echo "Backup x-ui file sent successfully to Discord webhook. Coded By SinaBigSmoke <3"