#!/bin/bash

# Requires the following environment variable to be set
#  DIR_TO_BACKUP
#  BACKUP_NAME Optional. Default is basename DIR_TO_BACKUP
#  BACKUP_ROOT optional. Default $HOME/backup/$backup_name

backup_name=${BACKUP_NAME:-`basename $DIR_TO_BACKUP`}
backup_root=${BACKUP_ROOT:-$HOME/backup/$backup_name}

backup_dir=$backup_root/`date +%Y-%m`
backup_file=$backup_dir/dir-${backup_name}-`date --iso-8601`.tar.gz

mkdir -p $backup_dir

/bin/tar cz --directory=`dirname $DIR_TO_BACKUP` \
	--file=$backup_file \
	`basename $DIR_TO_BACKUP`

export BACKUP_DIR=$backup_dir
export FILE_PATTERN="dir-${backup_name}-*.gz"
`dirname $0`\clean-old-backups.sh

