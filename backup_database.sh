#!/bin/bash

# Requires the following environment variable to be set
#  DATABASE
#  DBUSER
#  DBPASSWORD
#  Optional DBHOST (default localhost)
#  BACKUP_ROOT optional. Default $HOME/backup/$DATABASE

DBHOST=${DBHOST:-localhost}

backup_root=${BACKUP_ROOT:-$HOME/backup/$DATABASE}
backup_dir=$backup_root/`date +%Y-%m`

mkdir -p $backup_dir

/usr/bin/mysqldump --host=$DBHOST \
    --user=$DBUSER --password=$DBPASSWORD \
    $DATABASE | gzip > ${backup_dir}/dump-$DATABASE-`date +%Y-%m-%d`.gz

export BACKUP_DIR=$backup_dir
export FILE_PATTERN="dump-$DATABASE-*.gz"
bash `dirname $0`/clean-old-backups.sh
