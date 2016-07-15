#!/bin/bash

db_host=localhost
db_name=test
db_user=root
db_passwd=123

ftp_host=remote_ip
ftp_user=ftp_user_name
ftp_passwd=ftp_password
ftp_dir=/path/backup/


backup_file_name=$(date +"%Y-%b-%d-%H:%M")_$db_name;

# DUMP DB
# Add --routines for dump stored proceedures
# Add --triggers  for dump triggers 


mysqldump  -u$db_user -p$db_passwd $db_name > $backup_file_name.sql


ftp -n -v $ftp_host << EOT
ascii
prompt
user $ftp_user $ftp_passwd
mput *_$db_name.sql $ftp_dir
bye
EOT


rm *_$db_name.sql #Delete local backup file. 


# remote server cron job to delete backup files older than 5 days 
# 00 00 * * * /bin/find /path/to/files/*_$db_name.sql -type f -mtime +5 -exec rm -rf {} \;
