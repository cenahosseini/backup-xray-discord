#!/bin/bash #Coded by SinaBigSmoke

# Remove existing backup zip file
rm -rf /root/SinaBigSmoke-x.zip

# Create a zip file containing specified files
zip /root/SinaBigSmoke-x.zip /etc/x-ui/x-ui.db /usr/local/x-ui/config.json

# Add a comment to the zip file
echo -e "Created by SinaBigSmoke - https://github.com/SinaBigSmoke" | zip -z /root/SinaBigSmoke-x.zip

# Define Discord webhook URL
WEBHOOK_URL=""

# Define message to be sent along with the file
MESSAGE=""

# Define path to the zip file
FILE_PATH="/root/SinaBigSmoke-x.zip"

# Send the file using curl
curl -X POST -H "Content-Type: multipart/form-data" -F "content=$MESSAGE" -F "file=@$FILE_PATH" $WEBHOOK_URL