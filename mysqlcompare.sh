#!/bin/sh

#######################################################################
# Database comparision script based on mysqldiff
# Configuration: set MYSQL_ variables below
# Usage: ./mysqlcompare.sh database1 prefix1 database2 prefix2
#
#
# Warning! mysqldiff works incorrectly with multicolumn indexes!
# Use with caution!
#
# Written by 4X_Pro <admin@openproj.ru>
# http://intbpro.ru
#######################################################################

# Set this variables before using of script
MYSQL_HOST="localhost"
MYSQL_USER="root"
MYSQL_PASSWORD="1"
MYSQL_PORT="3306"
MYSQL_SOCKET="/var/run/mysqld/mysqld.sock"

[ $# -lt 4 ] && { echo "Usage: database1 prefix1 database2 prefix2"; exit 1; }
type mysqldiff > /dev/null 2>&1
if [ $? -ne 0 ]; then
 echo "Mysqldiff not found! This script requires it to work properly!";
 exit 2;
fi


TABLES=`echo "SHOW TABLES FROM $3 LIKE '$4%';" | mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -h$MYSQL_HOST -N`
echo $TABLES
for TABLE2 in $TABLES; do
  if [ "$4" != "" ]; then # if working in no-prefix mode
     TABLE=`echo $TABLE2|sed s/$4/$2/`
  else
     TABLE=$TABLE2
  fi
  RESULT=`mysqldiff "--server1=$MYSQL_USER:$MYSQL_PASSWORD@$MYSQL_HOST:$MYSQL_PORT:$MYSQL_SOCKET" "$1.$TABLE:$3.$TABLE2" --difftype=sql --character-set=utf8 -c -q --skip-table-options`
  if [ $? -ne 0 ]; then
    RESULT=`echo $RESULT|sed "s/# WARNING: Using a password on the command line interface can be insecure.//"`
    RESULT=`echo $RESULT|sed "s/# Transformation for --changes-for=server1: #//"`
    RESULT=`echo $RESULT|sed "s/\(DROP PRIMARY KEY, \)\1/\1/g"`
    if [ "$RESULT" != "ERROR: The object $1.$TABLE does not exist." ]; then
      echo $RESULT
    else
      CREATE=`echo "SHOW CREATE TABLE $3.$TABLE2;"|mysql -u$MYSQL_USER -p$MYSQL_PASSWORD -h$MYSQL_HOST -N`
      CREATE=`echo $CREATE|sed s/^$TABLE2//`
      CREATE=`echo $CREATE|sed s/\\\`$TABLE2\\\`/\\\`$1\\\`.\\\`$TABLE\\\`/`
      echo "$CREATE;"
    fi
  fi
done
