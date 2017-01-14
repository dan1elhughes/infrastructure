#!/bin/bash
# {{ ansible_managed }}

HOST="{{ ansible_hostname }}"
MYSQL_USER="{{ item.name }}"
MYSQL_PASSWORD="{{ item.password }}"
IS_VM="{{ is_vm | default('false') }}"

DATE=$(date +"%Y%m%d")
TIME=$(date +"%H%M")
BACKUP_DIR="/home/xes/backups"
MYSQL="$(which mysql)"
MYSQLDUMP="$(which mysqldump)"
EXCLUDED_DATABASES="information_schema|performance_schema|sys"

[ "$IS_VM" == "true" ] && HOST="v$HOST"

mkdir -p "$BACKUP_DIR"

databases=`$MYSQL --user=$MYSQL_USER -p$MYSQL_PASSWORD -e "SHOW DATABASES;" | grep -Ev "(Database|$EXCLUDED_DATABASES)"`
for db in $databases; do

	ascfile="$BACKUP_DIR/$db.${HOST}.${DATE}.${TIME}.sql.asc"

	$MYSQLDUMP --user=$MYSQL_USER -p$MYSQL_PASSWORD $db | gpg --encrypt --recipient {{ gpg_keynum }} --trust-model always --armor > "$ascfile"

done
