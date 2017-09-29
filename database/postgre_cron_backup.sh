#!/bin/bash
#
# Backup a Postgresql database into a daily file.
#

BACKUP_DIR=/home/dev/backup/database
DAYS_TO_KEEP=20
FILE_SUFFIX=_pg_backup.sql
DATABASE=database_name
USER=database_user
PASSWD=database_password
FILE=`date +"%Y%m%d%H%M"`${FILE_SUFFIX}

OUTPUT_FILE=${BACKUP_DIR}/${FILE}

# do the database backup (dump)
# use this command for a database server on localhost. add other options if need be.
#PGPASSWORD="RXTG8bs9NHuMNvwD" pg_dump -U ${USER} ${DATABASE} > ${OUTPUT_FILE}
pg_dump --dbname=postgresql://${USER}:${PASSWD}@localhost:5432/${DATABASE} > ${OUTPUT_FILE}

# gzip the mysql database dump file
gzip $OUTPUT_FILE

# show the user the result
echo "${OUTPUT_FILE}.gz was created:"
ls -l ${OUTPUT_FILE}.gz

# prune old backups
find $BACKUP_DIR -maxdepth 1 -mtime +$DAYS_TO_KEEP -name "*${FILE_SUFFIX}.gz" -exec rm -rf '{}' ';'
