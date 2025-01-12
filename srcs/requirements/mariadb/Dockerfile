FROM debian:stable

# Install MariaDB
RUN apt update -y && \
    apt upgrade -y && \
    apt install -y mariadb-server mariadb-client && \
    apt clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /var/run/mysqld && \
    mkdir -p /var/lib/mysql && \
    chown -R mysql:mysql /var/run/mysqld && \
    chown -R mysql:mysql /var/lib/mysql



COPY ./tools/mdbscript.sh /usr/local/bin
RUN chmod +x /usr/local/bin/mdbscript.sh

# Use the default entrypoint from the official MariaDB image to start MariaDB
USER mysql

EXPOSE 3306
ENTRYPOINT [ "/usr/local/bin/mdbscript.sh" ]

CMD ["mysqld", "--bind-address=0.0.0.0"]
# RUN mysql -u root -p rootpassword
# CMD ["mysqld", "-g", "daemon off"]


# Start MariaDB when the container runs
# CMD ["mysqld", "-g", "daemon off;"]