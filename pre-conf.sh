#!/bin/bash

/usr/bin/mysqld_safe &
 sleep 10s

 mysqladmin -u root password mysqlpsswd
 mysqladmin -u root -pmysqlpsswd reload
 mysqladmin -u root -pmysqlpsswd create  owncloud

 echo "GRANT ALL ON owncloud.* TO ownclouduser@localhost IDENTIFIED BY 'ownclouddbpasswd'; flush privileges; " | mysql -u root -pmysqlpsswd

 echo 'deb http://download.opensuse.org/repositories/isv:/ownCloud:/community/xUbuntu_14.04/ /' >> /etc/apt/sources.list.d/owncloud.list
 wget http://download.opensuse.org/repositories/isv:ownCloud:community/xUbuntu_14.04/Release.key
 DEBIAN_FRONTEND=noninteractive apt-key add - < Release.key
 DEBIAN_FRONTEND=noninteractive apt-get update -y -q
 DEBIAN_FRONTEND=noninteractive apt-get install -y -q owncloud
 chown -R www-data:www-data /usr/www/owncloud/data 
 
killall mysqld
sleep 10s

