#!/bin/bash

#Backup mysql
mysqldump -u root -pmysqlpsswd --all-databases > /var/backups/alldb_backup.sql

#Backup important file ... of the configuration ...
cp  /etc/workaround-docker-2267/hosts  /var/backups/

#Backup importand files relate to app
cp /var/www/owncloud/config/config.php /var/backups/
