#name of container: docker-owncloud
#versison of container: 1.0.0

FROM quantumobject/docker-baseimage
MAINTAINER Angel Rodriguez  "angel@quantumobject.com"

# Set correct environment variables.
ENV HOME /root

#General variable definition for generation ssl scription keys
ENV C US
ENV ST California
ENV L Sacramento
ENV O example
ENV OU IT Deparment
ENV CN example.com

#add repository and update the container
#Installation of nesesary package/software for this containers...
RUN echo "deb http://archive.ubuntu.com/ubuntu trusty-backports main restricted " >> /etc/apt/sources.list
RUN apt-get update && apt-get install -y -q  php5 \
                                             libapache2-mod-php5 \
                                             php5-gd apache2 \
                                             mysql-server \
                                             php-xml-parser \
                                             php5-intl \
                                             smbclient \
                                             php5-sqlite \
                                             php5-mysql \
                                             php5-json  \
                                             php5-curl  \
                                             libcurl3 \
                                             openssl  \
                      && apt-get clean \
                      && rm -rf /tmp/* /var/tmp/*  \
                      && rm -rf /var/lib/apt/lists/*

# to add mysqld deamon to runit
RUN mkdir /etc/service/mysqld
COPY mysqld.sh /etc/service/mysqld/run
RUN chmod +x /etc/service/mysqld/run

# to add apache2 deamon to runit
RUN mkdir /etc/service/apache2
COPY apache2.sh /etc/service/apache2/run
RUN chmod +x /etc/service/apache2/run

#to add startup.sh to be runs the scripts during startup
RUN mkdir -p /etc/my_init.d
COPY startup.sh /etc/my_init.d/startup.sh
RUN chmod +x /etc/my_init.d/startup.sh

#installing owncloud and creating database for it ....
COPY pre-conf.sh /sbin/pre-conf
RUN chmod +x /sbin/pre-conf \
    && /bin/bash -c /sbin/pre-conf \
    && rm /sbin/pre-conf

# configuration file for owncloud and apache2
COPY apache2.conf /etc/apache2/apache2.conf
COPY owncloud.conf /etc/apache2/conf.d/owncloud.conf
COPY 000-default.conf /etc/apache2/sites-available/000-default.conf
COPY default-ssl.conf /etc/apache2/sites-available/default-ssl.conf
COPY autoconfig.php /var/www/owncloud/config/autoconfig.php
RUN mkdir -p /etc/apache2/ssl \
    && rm -R /var/www/html  \
    && a2enmod ssl \
    && a2enmod rewrite \
    && a2enmod headers

##scritp that can be running from the outside using docker-bash tool ...
#backup scritp with need to be use with VOLUME /var/backups/
COPY backup.sh /sbin/backup
RUN chmod +x /sbin/backup
VOLUME /var/backups

#create Volume for the data for owncloud
VOLUME /var/data

#expose port for https service
EXPOSE 443

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]
