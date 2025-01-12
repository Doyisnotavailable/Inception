FROM debian:11

RUN apt update && apt install -y \ 
    php7.4 php7.4-cli php7.4-common \
    php7.4-imap php7.4-redis php7.4-snmp \ 
    php7.4-xml php7.4-mysqli php7.4-zip \
    php7.4-mbstring php7.4-curl libapache2-mod-php php-fpm\
    wget curl wordpress net-tools && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*


RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/bin/wp

COPY tools/wpscript.sh /usr/local/bin
RUN chmod +x /usr/local/bin/wpscript.sh

COPY tools/www.conf /etc/php7.4/php-fpm.d/

RUN mkdir -p /run/php && \
    chown -R www-data:www-data /run/php  && \
    chmod 755 /run/php

EXPOSE 9000

# Set permissions
RUN chown -R www-data:www-data /var/www/html

RUN sed -i "s|listen = /run/php/php7.4-fpm.sock|listen = 0.0.0.0:9000|" /etc/php/7.4/fpm/pool.d/www.conf

# WORKDIR /usr/local/bin
WORKDIR /var/www/html

ENTRYPOINT [ "/usr/local/bin/wpscript.sh" ]

# # Start PHPFPM 
# CMD ["php-fpm7.4", "-F"]
