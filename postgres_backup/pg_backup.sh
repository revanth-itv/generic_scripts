#!/bin/bash

backup_path="$2"
archive_path="$1"
timestamp=$(date +%Y-%m-%d_%H_%M_%S)
archive_filename=archive_$timestamp.log
backup_filename=backup_$timestamp.log
archive_log=$archive_filename
backup_log=$backup_filename
days=10
START_TIME=$(date +%s)


if [ "$(ls -b $backup_path | wc -l)" -gt 1 ]; then
     echo -e "$(find $backup_path* -mtime +$days)" >> $backup_log
else
    echo "There are no files to be deleted" >> $backup_log
fi

for i in `cat $backup_log` ;do rm -rf $i ;done


if [ "$(ls -b $archive_path | wc -l)" -gt 1 ]; then
     echo -e "$(find $archive_path* -mtime +$days)" >> $archive_log
else
    echo "There are no files to be deleted" >> $archive_log
fi

for i in `cat $archive_log` ;do rm -rf $i ;done

echo "Postgres Backup:: Script Start -- $(date +%Y-%m-%d_%H:%M)" >> $archive_log

pg_basebackup -Ft -D $backup_path"$(date +%Y-%m-%d-%H_%M_%S)" >> $backup_log


END_TIME=$(date +%s)

ELAPSED_TIME=$(( $END_TIME - $START_TIME ))

echo "Postgres Backup :: Script End -- $(date +%Y-%m-%d_%H:%M)" >> $archive_log

echo "Elapsed Time ::  $(date -d 00:00:$ELAPSED_TIME +%Hh:%Mm:%Ss) "  >> $archive_log