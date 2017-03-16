#!/bin/sh
#########################################
# Simple MySQL database backup script
# Can make daily, weekly and monthly copy of databases
# Structure of tables stored in separate file from data to make easy partial recovery
# Written by 4X_Pro <admin@openproj.ru>
# Don't forget to chmod +x backup.sh
# and set MYSQL_USER, MYSQL_PASSWORD and ADMIN_EMAIL below
#
# Usage ./backup.sh database1 database2 ...
#
# or add to crontab something like
#      0 3 * * * <path_to>/backup.sh database1 database2
#########################################

MYSQL_USER="root"  # MySQL user name
MYSQL_PASSWORD="password" # MySQL password
ADMIN_EMAIL="admin@example.com" # Email to send notifications if backup can't be done
BACKUP_DIR="/root/backup" # Directory where backups should be stored

[ $# -eq 0 ] && { echo "Usage: $0 database1 database2 and so on"; exit 1; }

cd $BACKUP_DIR

for BASE in $@; do

  if [ -f $BASE.sql.gz ]; then
    if [ `date +%u` -eq 1 ]; then
      cp $BASE.sql.gz $BASE.weekly.sql.gz
    fi

    if [ `date +%d` -eq 1 ]; then
      cp $BASE.sql.gz $BASE.monthly.sql.gz
    fi
     mv $BASE.sql.gz $BASE.yesterday.sql.gz
  fi

  mysqldump --replace --no-create-info -u $MYSQL_USER -p$MYSQL_PASSWORD $BASE > $BASE.sql
  if [ $? -eq 0 -a -s $BASE.sql ]; then
     mysqldump --no-data -u $MYSQL_USER -p$MYSQL_PASSWORD $BASE > $BASE.struct.sql
     gzip $BASE.sql
  else
     echo "Backup of base $BASE on `hostname -f` failed!" | mail -s "Backup failed" $ADMIN_EMAIL
  fi

done
