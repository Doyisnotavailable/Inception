#!/bin/sh

if [ -f ./wp-config.php ]
then
	echo "Wordpress already exists"
else
	wp core download --allow-root
    
    #wp config create --dbname=<dbname> --dbuser=<dbuser> [--dbpass=<dbpass>]
    # creating wp-config.php ..... 
    wp config create --allow-root \
        --dbname=$MYSQL_DATABASE \
        --dbuser=$MYSQL_USER \
        --dbpass=$MYSQL_PASSWORD \
        --dbhost=$MYSQL_HOSTNAME \
        --dbcharset="utf8"
    
    if [ $? -ne 0 ]; then
        echo "Failure to create wp-conf file!!!!!!!!!!!!"
        return 1
    fi
    echo "wp-conf file!!!!!!!!!!!!"

    wp core install --allow-root --url=$DOMAIN_NAME \
        --title=$WP_TITLE \
        --admin_user=$WP_ADMIN_USR \
        --admin_password=$WP_ADMIN_PWD \
        --admin_email=$WP_ADMIN_EMAIL
	
    if [ $? -ne 0 ]; then
        echo "Failure to create ADMIN user ......"
        return 1
    fi
    echo "created ADMIN user ......"
    
    wp user create --allow-root $WP_USER $WP_EMAIL --role=author --user_pass=$WP_PASSWORD
    wp user create --allow-root "student" "student@42.fr" --role=author --user_pass="s123"

    if [ $? -ne 0 ]; then
        echo "Failure to create NORMAL user ......"
        return 1
    fi
    echo "created NORMAL user ......"
fi

php-fpm7.4 -F