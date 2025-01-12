#!/bin/sh

# Ensure necessary environment variables are set
if [ -z "$MYSQL_DATABASE" ] || [ -z "$MYSQL_ROOT_PASSWORD" ] || [ -z "$MYSQL_USER" ] || [ -z "$MYSQL_PASSWORD" ]; then
  echo "Required environment variables are missing. Exiting."
  exit 1
fi

# Initialize MySQL database
mysql_install_db

/etc/init.d/mysql start

# Check if the database exists
if [ -d "/var/lib/mysql/$MYSQL_DATABASE" ]; then
  echo "Database already exists"
else
  # Secure MySQL by configuring root password and removing test database
  mysql -uroot <<_EOF_
    UPDATE mysql.user SET Password=PASSWORD('$MYSQL_ROOT_PASSWORD') WHERE User='root';
    DELETE FROM mysql.user WHERE User='';
    UPDATE mysql.user SET Host='localhost' WHERE User='root';
    DROP DATABASE IF EXISTS test;
    DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
    FLUSH PRIVILEGES;
_EOF_

  # Add a root user for remote connections
  echo "GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD'; FLUSH PRIVILEGES;" | mysql -uroot

  # Create the WordPress database and user
  echo "CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE; GRANT ALL ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD'; FLUSH PRIVILEGES;" | mysql -u root

  # Import the database from the SQL file if it exists
  if [ -f /usr/local/bin/wordpress.sql ]; then
    mysql -uroot -p$MYSQL_ROOT_PASSWORD $MYSQL_DATABASE < /usr/local/bin/wordpress.sql
  else
    echo "WordPress SQL file not found. Skipping import."
  fi
fi

# Stop MySQL after setup
/etc/init.d/mysql stop

# Execute any additional command passed to the container/script
exec "$@"
