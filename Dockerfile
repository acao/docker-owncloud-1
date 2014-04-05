# owncloud6 container
# VERSION               0.1.0

FROM angelrr7702/ubuntu-13.10-sshd

MAINTAINER Angel Rodriguez  "angelrr7702@gmail.com"

RUN echo "deb http://archive.ubuntu.com/ubuntu saucy-backports main restricted "                                                                                                  >> /etc/apt/sources.list
ENV DEBIAN_FRONTEND noninteractive

RUN (apt-get update && apt-get upgrade -y -q && apt-get dist-upgrade -y -q && ap                                                                                                 t-get -y -q autoclean && apt-get -y -q autoremove)
RUN apt-get install -y -q supervisor php5 libapache2-mod-php5 php5-gd apache2 my                                                                                                 sql-server php-xml-parser php5-intl smbclient php5-sqlite php5-mysql php5-json c                                                                                                 ron php5-curl curl libcurl3 openssl

ADD start.sh /start.sh
ADD foreground.sh /etc/apache2/foreground.sh
ADD pre-conf.sh /pre-conf.sh
ADD apache2.conf /etc/apache2/apache2.conf
ADD owncloud.conf /etc/apache2/conf.d/owncloud.conf
ADD 000-default.conf /etc/apache2/sites-available/000-default.conf
ADD default-ssl.conf /etc/apache2/sites-available/default-ssl.conf
RUN mkdir -p /etc/apache2/ssl

RUN (chmod 750 /start.sh && chmod 750 /etc/apache2/foreground.sh && chmod 750 /p                                                                                                 re-conf.sh)
RUN (/bin/bash -c /pre-conf.sh)

RUN ( a2enmod ssl && a2enmod rewrite)

RUN mkdir -p /var/log/supervisor
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

EXPOSE 22 443
CMD ["/bin/bash", "-e", "/start.sh"]
