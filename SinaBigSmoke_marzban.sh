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
sudo rm -rf /root/SinaBigSmoke-m.zip
FILE_PATH="/root/SinaBigSmoke-m.zip"
echo "Current system time:"
date
echo "Chosen cron job schedule:"
echo "$CRON_JOB"
echo "Cron jobs:"
sudo crontab -l
echo "$CRON_JOB /bin/bash /root/SinaBigSmoke_marzban.sh" | sudo crontab -

if dir=$(find /opt /root -type d -iname "marzban" -print -quit); then
    echo "The folder exists at $dir"
else
    echo "The folder does not exist."
    exit 1
fi

if [ -d "/var/lib/marzban/mysql" ]; then
    sed -i -e 's/\s*=\s*/=/' -e 's/\s*:\s*/:/' -e 's/^\s*//' /opt/marzban/.env
    docker exec marzban-mysql-1 bash -c "mkdir -p /var/lib/mysql/db-backup"
    source /opt/marzban/.env
    cat > "/var/lib/marzban/mysql/SinaBigSmoke_marzban.sh" <<EOL
#!/bin/bash
USER="root"
PASSWORD="$MYSQL_ROOT_PASSWORD"
databases=\$(mysql -h 127.0.0.1 --user=\$USER --password=\$PASSWORD -e "SHOW DATABASES;" | tr -d "| " | grep -v Database)
for db in \$databases; do
    if [[ "\$db" != "information_schema" ]] && [[ "\$db" != "mysql" ]] && [[ "\$db" != "performance_schema" ]] && [[ "\$db" != "sys" ]] ; then
        echo "Dumping database: \$db"
        mysqldump -h 127.0.0.1 --force --opt --user=\$USER --password=\$PASSWORD --databases \$db > /var/lib/mysql/db-backup/\$db.sql
    fi
done
EOL
    chmod +x /var/lib/marzban/mysql/SinaBigSmoke_marzban.sh
    ZIP=$(cat <<EOF
docker exec marzban-mysql-1 bash -c "/var/lib/mysql/SinaBigSmoke_marzban.sh"
zip -r $FILE_PATH /opt/marzban/* /var/lib/marzban/* /opt/marzban/.env -x /var/lib/marzban/mysql/\*
zip -r $FILE_PATH /var/lib/marzban/mysql/db-backup/*
rm -rf /var/lib/marzban/mysql/db-backup/*
EOF
    )
else
    ZIP="zip -r $FILE_PATH ${dir}/* /var/lib/marzban/* /opt/marzban/.env"
fi

curl -X POST -H "Content-Type: multipart/form-data" -F "content=$MESSAGE" -F "file=@$FILE_PATH" $WEBHOOK_URL
echo "Backup marzban file sent successfully to Discord webhook. Coded By SinaBigSmoke <3"