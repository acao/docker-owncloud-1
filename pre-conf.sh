#!/bin/bash

/usr/bin/mysqld_safe &
 sleep 10s

 mysqladmin -u root password mysqlpsswd
 mysqladmin -u root -pmysqlpsswd reload
 mysqladmin -u root -pmysqlpsswd create  owncloud

 echo "GRANT ALL ON owncloud.* TO ownclouduser@localhost IDENTIFIED BY 'ownclouddbpasswd'; flush privileges; " | mysql -u root -pmysqlpsswd

 echo 'deb http://download.opensuse.org/repositories/isv:/ownCloud:/community/xUbuntu_13.10/ /' >> /etc/apt/sources.list.d/owncloud.list
 wget http://download.opensuse.org/repositories/isv:ownCloud:community/xUbuntu_13.10/Release.key
 DEBIAN_FRONTEND=noninteractive apt-key add - < Release.key
 DEBIAN_FRONTEND=noninteractive apt-get update -y -q
 DEBIAN_FRONTEND=noninteractive apt-get install -y -q owncloud

killall mysqld
sleep 10s

