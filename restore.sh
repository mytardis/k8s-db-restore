cd pg_restore/db_backups

EXIT_CODE=0
BACKUP_FOLDER=`ls -td -- k8s-backup-*/ | head -n 1`

echo "Disallow new connections"
psql -d $PGDATABASE -c "REVOKE CONNECT ON DATABASE $PGDATABASE FROM public;"

echo "Terminate existing connections"
psql -d $PGDATABASE -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname='$PGDATABASE' AND pid<>pg_backend_pid();"

echo "Clean database"
psql -d $PGDATABASE -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public; GRANT ALL ON SCHEMA public TO public;"

echo "Restoring latest dump: $BACKUP_FOLDER"
pg_restore -d $PGDATABASE --format=directory $BACKUP_FOLDER
# https://www.postgresql.org/docs/9.6/app-pgrestore.html

if [ $? -ne 0 ]; then
  echo "Restore not completed, check logs for details"
  EXIT_CODE=1
else
  echo "Successfully restored backup"
fi

echo "Enable new connection"
psql -d $PGDATABASE -c "GRANT CONNECT ON DATABASE $PGDATABASE TO public;"

exit $EXIT_CODE
