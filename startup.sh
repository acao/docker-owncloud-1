#!/bin/bash


set -e

if [ -f /configured ]; then
        echo 'already configured'
else
        openssl req -new -x509 -days 365 -nodes -subj "/C=$C/ST=$ST/L=$L/O=$O/OU=$OU/CN=$CN"  -out /etc/apache2/ssl/owncloud.pem -keyout /etc/apache2/ssl/owncloud.key
        chown -R www-data:www-data /var/www/owncloud/data
        sed -i 's/ServerName example.com/ServerName $CN/' /etc/apache2/conf.d/owncloud.conf
        #to include the domain to the hosts
        echo 127.0.0.1 $CN >> /etc/workaround-docker-2267/hosts
        #needed to fix problem with ubuntu ... and cron 
        update-locale
        date > /configured
fi


