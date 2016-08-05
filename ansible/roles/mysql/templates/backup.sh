#!/bin/bash

TIMESTAMP=$(date +"%Y%m%d")
BACKUP_DIR=$(mktemp -d)
HOST="{{ ansible_hostname }}.{{ type }}"
MAILGUN_API_KEY="{{ mailgun_api_key }}"
SRC_EMAIL="{{ backup_src_email }}"
DEST_EMAIL="{{ backup_dest_email }}"

MYSQL_USER="{{ item.name }}"
MYSQL=/usr/bin/mysql
MYSQL_PASSWORD="{{ item.password }}"
MYSQLDUMP=/usr/bin/mysqldump

databases=`$MYSQL --user=$MYSQL_USER -p$MYSQL_PASSWORD -e "SHOW DATABASES;" | grep -Ev "(Database|information_schema|mysql|performance_schema)"`

for db in $databases; do

    $MYSQLDUMP --user=$MYSQL_USER -p$MYSQL_PASSWORD $db > "$BACKUP_DIR/${TIMESTAMP}_$db.$HOST.sql"
    gpg --encrypt --recipient {{ gpg_keynum }} --trust-model always --armor "$BACKUP_DIR/${TIMESTAMP}_$db.$HOST.sql"

    curl -s --user "api:${MAILGUN_API_KEY}" \
        https://api.mailgun.net/v3/xes.io/messages \
        -F from="Database backups <${SRC_EMAIL}>" \
        -F to="${DEST_EMAIL}" \
        -F subject="${db} backup for ${TIMESTAMP}" \
        -F text='[Auto] Backups attached.' \
        -F attachment=@$BACKUP_DIR/${TIMESTAMP}_$db.${HOST}.sql.asc > /dev/null

    if [[ $? -eq 0 ]]; then
        rm $BACKUP_DIR/${TIMESTAMP}_$db.${HOST}.sql
        rm $BACKUP_DIR/${TIMESTAMP}_$db.${HOST}.sql.asc
    fi

done
