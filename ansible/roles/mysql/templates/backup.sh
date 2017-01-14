#!/bin/bash
# {{ ansible_managed }}

TIMESTAMP=$(date +"%Y%m%d")
BACKUP_DIR="$(mktemp -d)"
HOST="{{ ansible_hostname }}"
MAILGUN_API_KEY="{{ item.email_key }}"
SRC_EMAIL="{{ item.email_src }}"
DEST_EMAIL="{{ item.email_dest }}"

MYSQL_USER="{{ item.name }}"
MYSQL="$(which mysql)"
MYSQL_PASSWORD="{{ item.password }}"
MYSQLDUMP="$(which mysqldump)"

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
