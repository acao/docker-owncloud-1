#!/bin/bash


set -e

if [ -f /configured ]; then
  exec /usr/bin/supervisord
fi

openssl req -new -x509 -days 365 -nodes -subj "/C=$C/ST=$ST/L=$L/O=$O/OU=$OU/CN=$CN"  -out /etc/apache2/ssl/owncloud.pem -keyout /etc/apache2/ssl/owncloud.key

date > /configured
exec /usr/bin/supervisord

