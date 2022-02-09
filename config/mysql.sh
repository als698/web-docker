#!/bin/bash

chmod 777 -R /db
if [ ! -d "/run/mysqld" ]; then
    mkdir -p /run/mysqld
fi

if [ "$MYSQL_ROOT_PASSWORD" = "" ]; then
    MYSQL_ROOT_PASSWORD="t0rpas"
    echo $(date '+%Y-%m-%d %H:%M:%S') "mysql [info]: MySQL root Password: $MYSQL_ROOT_PASSWORD"
fi

if [ "$MYSQL_DATABASE" = "" ]; then
    MYSQL_DATABASE="app"
    echo $(date '+%Y-%m-%d %H:%M:%S') "mysql [info]: MySQL database: $MYSQL_DATABASE"
fi

if [ "$MYSQL_USER" = "" ]; then
    MYSQL_USER="dbus3r"
    echo $(date '+%Y-%m-%d %H:%M:%S') "mysql [info]: MySQL user: $MYSQL_USER"
fi

if [ "$MYSQL_PASSWORD" = "" ]; then
    MYSQL_PASSWORD="dbpas"
    echo $(date '+%Y-%m-%d %H:%M:%S') "mysql [info]: MySQL $MYSQL_USER password: $MYSQL_PASSWORD"
fi

tfile=`mktemp`
if [ ! -f "$tfile" ]; then
    return 1
fi

if [ -d /db/data/mysql ]; then
    echo $(date '+%Y-%m-%d %H:%M:%S') "mysql [info]: MySQL directory already present, skipping creation"
else
    echo $(date '+%Y-%m-%d %H:%M:%S') "mysql [info]: creating database"
    mysql_install_db --user=nobody > /dev/null
    echo "USE mysql;" >> $tfile
    echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION;" >> $tfile
    echo "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY '' WITH GRANT OPTION;" >> $tfile
    echo "DROP DATABASE IF EXISTS test;" >> $tfile
    echo "FLUSH PRIVILEGES;" >> $tfile
fi

if [ -d /db/data/${MYSQL_DATABASE} ]; then
    echo $(date '+%Y-%m-%d %H:%M:%S') "mysql [info]: $MYSQL_DATABASE already present, skipping creation"
else
    echo $(date '+%Y-%m-%d %H:%M:%S') "mysql [info]: $MYSQL_DATABASE not found, creating initial DBs"
    echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\` CHARACTER SET utf8 COLLATE utf8_general_ci;" >> $tfile
fi

echo $(date '+%Y-%m-%d %H:%M:%S') "mysql [info]: creating $MYSQL_USER"
# echo "CREATE USER \`$MYSQL_USER\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';" >> $tfile
echo $(date '+%Y-%m-%d %H:%M:%S') "mysql [info]: grant privileges $MYSQL_USER to $MYSQL_DATABASE"
echo "GRANT ALL ON \`$MYSQL_DATABASE\`.* TO \`$MYSQL_USER\`@'%' IDENTIFIED BY '$MYSQL_PASSWORD';" >> $tfile
echo "GRANT ALL ON \`$MYSQL_DATABASE\`.* TO \`$MYSQL_USER\`@'localhost' IDENTIFIED BY '$MYSQL_PASSWORD';" >> $tfile

/usr/bin/mysqld --skip-networking &
pid="$!"

mysql=( mysql --protocol=socket --socket=/run/mysqld/mysqld.sock )

for i in {30..0}; do
    echo $(date '+%Y-%m-%d %H:%M:%S') "mysql [info]: MySQL init process in progress..."
    if echo 'SELECT 1' | "${mysql[@]}" &> /dev/null; then
        break
    fi
    
    sleep 1
done

if [ "$i" = 0 ]; then
    echo >&2 $(date '+%Y-%m-%d %H:%M:%S') "mysql [info]: MySQL init process failed."
    exit 1
else
    echo $(date '+%Y-%m-%d %H:%M:%S') "mysql [info]: Database initiated [1/2]"
fi

if [ "$IMPORT_DB" = "1" ]; then
    echo $(date '+%Y-%m-%d %H:%M:%S') "mysql [info]: importing /db/import.sql to $MYSQL_DATABASE"
    echo "USE $MYSQL_DATABASE;" >> $tfile
    echo "source /db/import.sql;" >> $tfile
fi

"${mysql[@]}" < $tfile

if ! kill -s TERM "$pid" || ! wait "$pid"; then
    echo >&2 $(date '+%Y-%m-%d %H:%M:%S') "mysql [info]: MySQL init process failed."
    exit 1
else
    echo $(date '+%Y-%m-%d %H:%M:%S') "mysql [info]: Database initiated [2/2]"
fi

rm -f $tfile

echo $(date '+%Y-%m-%d %H:%M:%S') "STARTING DATABASE"

exec /usr/bin/mysqld