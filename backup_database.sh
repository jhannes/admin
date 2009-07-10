#!/bin/bash

# Requires the following environment variable to be set
#  DATABASE
#  DBUSER
#  DBPASSWORD

DBHOST=${DBHOST:-localhost}
archive_count=${ARCHIEVE_COUNT:-7}

backup_root=$HOME/backup/$DATABASE
backup_dir=$backup_root/`date +%Y-%m`
file_pattern="dump-$DATABASE-*.gz"

mkdir -p $backup_dir

/usr/bin/mysqldump --host=$DBHOST \
    --user=$DBUSER --password=$DBPASSWORD \
    $DATABASE | gzip > ${backup_dir}/dump-$DATABASE-`date +%Y-%m-%d`.gz

# Delete all but the newest backups
(cd $backup_dir; [ -n "`ls -tr $file_pattern | head --lines=-$archive_count`" ] && ls -tr $file_pattern | head --lines=-$archive_count | xargs rm)

# Delete all but the latest file in previous months backup
for dir in `ls -d $backup_root/* | head --lines=-1`
do
  (cd $dir; [ -n "`ls -tr $file_pattern | head --lines=-1`" ] && ls -tr $file_pattern | head --lines=-1 | xargs rm)
done

