FROM debian:11

# Install MariaDB
RUN apt-get update -y && \
    apt-get install -y mariadb-server mariadb-client && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create necessary directories and set permissions
RUN mkdir -p /var/run/mysqld /var/lib/mysql && \
    chown -R mysql:mysql /var/run/mysqld /var/lib/mysql /etc/mysql/

# Copy initialization script
COPY ./tools/mdbscript.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# Set environment variables with defaults
ENV MYSQL_DATABASE=$MYSQL_DATABASE \
    MYSQL_USER=$MYSQL_USER \
    MYSQL_PASSWORD=$MYSQL_PASSWORD \
    MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD

# Expose MariaDB port
EXPOSE 3306

# Switch to mysql user for security
USER mysql

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["mysqld", "--bind-address=0.0.0.0"]