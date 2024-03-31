#!/bin/bash

CONFIG_FILE="config.txt"

# Function to get input from user and save it to config file
get_input_and_save() {
    read -p "$1" INPUT
    echo "$INPUT" >> "$CONFIG_FILE"
}

# Function to read input from config file
read_input_from_config() {
    INPUT=$(sed -n "$1p" "$CONFIG_FILE")
}

# Check if config file exists and is readable
if [ -f "$CONFIG_FILE" ] && [ -r "$CONFIG_FILE" ]; then
    # Read input from config file
    read_input_from_config 1
    WEBHOOK_URL="$INPUT"
    read_input_from_config 2
    MESSAGE="$INPUT"
    read_input_from_config 3
    CRON_JOB="$INPUT"
else
    # If config file does not exist or is not readable, create it
    touch "$CONFIG_FILE"
    # Get input from user and save it to config file
    get_input_and_save "Please enter the Discord webhook URL: "
    get_input_and_save "Please enter the message: "
    get_input_and_save "Please enter the cron job schedule (e.g., '0 0 * * *' for daily at midnight): "
    # Read input from config file
    read_input_from_config 1
    WEBHOOK_URL="$INPUT"
    read_input_from_config 2
    MESSAGE="$INPUT"
    read_input_from_config 3
    CRON_JOB="$INPUT"
fi

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
