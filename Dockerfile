# owncloud6 container
# VERSION               0.1.0
FROM angelrr7702/ubuntu-13.10-sshd
MAINTAINER Angel Rodriguez  "angelrr7702@gmail.com"
RUN echo "deb http://archive.ubuntu.com/ubuntu saucy-backports main restricted " >> /etc/apt/sources.list
ENV C US
ENV ST California
ENV L Sacramento
ENV O example
ENV OU IT Deparment
ENV CN example
RUN (DEBIAN_FRONTEND=noninteractive apt-get update &&  DEBIAN_FRONTEND=noninteractive apt-get upgrade -y -q && DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y -q )
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -q supervisor php5 libapache2-mod-php5 php5-gd apache2 mysql-server php-xml-parser php5-intl smbclient php5-sqlite php5-mysql php5-json cron php5-curl curl libcurl3 openssl
ADD start.sh /start.sh
ADD foreground.sh /etc/apache2/foreground.sh
ADD pre-conf.sh /pre-conf.sh
ADD apache2.conf /etc/apache2/apache2.conf
ADD owncloud.conf /etc/apache2/conf.d/owncloud.conf
ADD 000-default.conf /etc/apache2/sites-available/000-default.conf
ADD default-ssl.conf /etc/apache2/sites-available/default-ssl.conf
RUN mkdir -p /etc/apache2/ssl
RUN (chmod 750 /start.sh && chmod 750 /etc/apache2/foreground.sh && chmod 750 /pre-conf.sh)
RUN (/bin/bash -c /pre-conf.sh)
RUN ( a2enmod ssl && a2enmod rewrite)
RUN mkdir -p /var/log/supervisor
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 22 443
VOLUME ["/var/www/owncloud/data", "/var/log/supervisor"]
CMD ["/bin/bash", "-e", "/start.sh"]
