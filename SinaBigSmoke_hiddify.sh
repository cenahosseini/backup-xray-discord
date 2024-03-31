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
sudo rm -rf /root/SinaBigSmoke-h.zip

# Define path to the zip file
FILE_PATH="/root/SinaBigSmoke-h.zip"

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
echo "$CRON_JOB /bin/bash /root/SinaBigSmoke_hiddify.sh" | sudo crontab -

# Define message for Hiddify backup
if hiddify_dir=$(find /opt -type d -iname "hiddify-panel" -print -quit); then
    echo "The Hiddify folder exists at $hiddify_dir"
else
    echo "The Hiddify folder does not exist."
    exit 1
fi

# Hiddify Backup
if find /opt/hiddify-config/hiddify-panel/ -type d -iname "backup" -print -quit; then
    echo "The Hiddify backup folder exists."
else
    echo "The Hiddify backup folder does not exist."
    exit 1
fi

ZIP_HIDDIFY=$(cat <<EOF
cd /opt/hiddify-config/hiddify-panel/
if [ \$(find /opt/hiddify-config/hiddify-panel/backup -type f | wc -l) -gt 100 ]; then
  find /opt/hiddify-config/hiddify-panel/backup -type f -delete
fi
python3 -m hiddifypanel backup
cd /opt/hiddify-config/hiddify-panel/backup
latest_file=\$(ls -t *.json | head -n1)
rm -f /root/SinaBigSmoke-h.zip
zip /root/SinaBigSmoke-h.zip /opt/hiddify-config/hiddify-panel/backup/\$latest_file
EOF
)

# Send the Hiddify backup file using curl
curl -X POST -H "Content-Type: multipart/form-data" -F "content=$MESSAGE" -F "file=@$FILE_PATH" $WEBHOOK_URL

# Display success message
echo "Backup hiddify sent successfully to Discord webhook. Coded By SinaBigSmoke <3"
