#!/bin/bash
set -e

# Initialize the MySQL data directory if needed
if [ ! -d "/var/lib/mysql/mysql" ]; then
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# Start MySQL server in the background for initialization
mysqld --user=mysql --skip-networking &
pid="$!"

# Wait for MySQL to start
until mysqladmin ping >/dev/null 2>&1; do
    echo -n "."
    sleep 1
done

# Initialize database if it doesn't exist
if [ ! -d "/var/lib/mysql/$MYSQL_DATABASE" ]; then
    # First, set up root without password temporarily
    mysql --user=mysql <<-EOSQL
        USE mysql;
        FLUSH PRIVILEGES;
        -- Set root password and privileges
        SET PASSWORD FOR 'root'@'localhost' = PASSWORD('${MYSQL_ROOT_PASSWORD}');
        GRANT ALL ON *.* TO 'root'@'localhost' WITH GRANT OPTION;
        FLUSH PRIVILEGES;
EOSQL

    # Now use root with password for remaining setup
    mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" <<-EOSQL
        -- Remove anonymous users
        DELETE FROM mysql.user WHERE User='';
        -- Create database and user
        CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\`;
        CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
        GRANT ALL ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'%';
        -- Remove test database
        DROP DATABASE IF EXISTS test;
        DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
        FLUSH PRIVILEGES;
EOSQL

    # Import WordPress database if SQL file exists
    if [ -f /usr/local/bin/wordpress.sql ]; then
        mysql -uroot -p"${MYSQL_ROOT_PASSWORD}" "$MYSQL_DATABASE" < /usr/local/bin/wordpress.sql
    fi
fi

# Stop the temporary server
if ! kill -s TERM "$pid" || ! wait "$pid"; then
    echo >&2 'MySQL initialization process failed.'
    exit 1
fi

# Start MySQL with the provided arguments
if [ "${1}" = 'mysqld' ]; then
    exec mysqld --user=mysql --bind-address=0.0.0.0
else
    exec "$@"
fi