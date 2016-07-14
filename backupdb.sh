#!/bin/bash

db_host=localhost
db_name=database
db_user=root
db_passwd=pass

ftp_host=remote_ip
ftp_user=ftp_user_name
ftp_passwd=ftp_password
ftp_dir=/home/


backup_file_name=$(date +"%Y-%b-%d-%H:%M")_$db_name;

# DUMP DB
# Add --routines for dump stored proceedures
# Add --triggers  for dump triggers 

mysqldump --single-transaction --user=$db_user --password=$db_passwd --host=$db_host $db_name > $backup_file_name.sql


ftp -n -v $ftp_host << EOT
ascii
prompt
user $ftp_user $ftp_passwd
mput *_$db_name.sql $ftp_dir
bye
EOT


rm *_$db_name.sql
