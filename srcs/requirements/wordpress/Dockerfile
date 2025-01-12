FROM debian:stable

RUN apt update && apt install -y \ 
    php8.2 php8.2-cli php8.2-common \
    php8.2-imap php8.2-redis php8.2-snmp \ 
    php8.2-xml php8.2-mysqli php8.2-zip \
    php8.2-mbstring php8.2-curl libapache2-mod-php php-fpm\
    wget curl wordpress && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*


RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar


RUN chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin

COPY tools/wpscript.sh /usr/local/bin

RUN chmod +x /usr/local/bin/wpscript.sh

EXPOSE 9000

# Set permissions
RUN chown -R www-data:www-data /var/www/html

# WORKDIR /usr/local/bin
WORKDIR /var/www/html

ENTRYPOINT [ "/usr/local/bin/wpscript.sh" ]

# # Start PHPFPM 
CMD ["php-fpm8.2", "-F"]
