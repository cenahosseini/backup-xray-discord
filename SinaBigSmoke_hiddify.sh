#!/bin/bash

CONFIG_FILE_WEBHOOK="webhook.txt"
CONFIG_FILE_MESSAGE="message.txt"
CONFIG_FILE_CRON="cron.txt"

get_input_and_save() {
    read -p "$1" INPUT
    echo "$INPUT" > "$2"
}

read_input_from_config() {
    INPUT=$(cat "$1")
}

if [ ! -f "$CONFIG_FILE_WEBHOOK" ] || [ ! -f "$CONFIG_FILE_MESSAGE" ] || [ ! -f "$CONFIG_FILE_CRON" ]; then
    get_input_and_save "Please enter the Discord webhook URL: " "$CONFIG_FILE_WEBHOOK"
    get_input_and_save "Please enter the message: " "$CONFIG_FILE_MESSAGE"
    get_input_and_save "Please enter the cron job schedule (e.g., '0 0 * * *' for daily at midnight): " "$CONFIG_FILE_CRON"
fi

read_input_from_config "$CONFIG_FILE_WEBHOOK"
WEBHOOK_URL="$INPUT"

read_input_from_config "$CONFIG_FILE_MESSAGE"
MESSAGE="$INPUT"

read_input_from_config "$CONFIG_FILE_CRON"
CRON_JOB="$INPUT"

sudo apt update
sudo apt install zip -y
sudo rm -rf /root/SinaBigSmoke-h.zip
FILE_PATH="/root/SinaBigSmoke-h.zip"
echo "Current system time:"
date
echo "Chosen cron job schedule:"
echo "$CRON_JOB"
echo "Cron jobs:"
sudo crontab -l
echo "$CRON_JOB /bin/bash /root/SinaBigSmoke_hiddify.sh" | sudo crontab -

if hiddify_dir=$(find /opt -type d -iname "hiddify-panel" -print -quit); then
    echo "The Hiddify folder exists at $hiddify_dir"
else
    echo "The Hiddify folder does not exist."
    exit 1
fi

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

curl -X POST -H "Content-Type: multipart/form-data" -F "content=$MESSAGE" -F "file=@$FILE_PATH" $WEBHOOK_URL
echo "Backup hiddify sent successfully to Discord webhook. Coded By SinaBigSmoke <3"