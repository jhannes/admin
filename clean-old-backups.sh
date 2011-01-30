#!/bin/bash

# Will delete old backups
#  Will assume structure of backup_root/yyyy-mm/filename-yyyy-mm-dd.ext
#  Will keep latest backup per month and latest 7 of current month

# Requires the following environment variable to be set
#  BACKUP_DIR
#  FILE_PATTERN
#  Optional: BACKUP_ROOT (default dirname BACKUP_DIR
#  Optional: ARCHIVE_COUNT how many backups to keep (default 7)

archive_count=${ARCHIVE_COUNT:-7}
backup_root=${BACKUP_ROOT:-`dirname BACKUP_DIR}

# Delete all but the newest $archive_count backups
(cd $BACKUP_DIR; [ -n "`ls -tr $FILE_PATTERN | head --lines=-$archive_count`" ] && ls -tr $FILE_PATTERN | head --lines=-$archive_count | xargs rm)

# Delete all but the latest file in previous months backup
for dir in `ls -d $backup_root/* | head --lines=-1`
do
  (cd $dir; [ -n "`ls -tr $file_pattern | head --lines=-1`" ] && ls -tr $file_pattern | head --lines=-1 | xargs rm)
done

