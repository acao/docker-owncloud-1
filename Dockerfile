#name of container: docker-owncloud
#versison of container: 0.1.5

FROM angelrr7702/docker-baseimage
MAINTAINER Angel Rodriguez  "angelrr7702@gmail.com"

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
RUN echo "deb http://archive.ubuntu.com/ubuntu trusty-backports main restricted " >> /etc/apt/sources.list
RUN (DEBIAN_FRONTEND=noninteractive apt-get update &&  DEBIAN_FRONTEND=noninteractive apt-get upgrade -y -q && DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y -q )
#Installation of nesesary package/software for this containers...
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y -q  php5 libapache2-mod-php5 php5-gd apache2 mysql-server php-xml-parser php5-intl smbclient php5-sqlite php5-mysql php5-json php5-curl curl libcurl3 openssl

# to add mysqld deamon to runit
RUN mkdir /etc/service/mysqld
ADD mysqld.sh /etc/service/mysqld/run
RUN chmod +x /etc/service/mysqld/run

# to add apache2 deamon to runit
RUN mkdir /etc/service/apache2
ADD apache2.sh /etc/service/apache2/run
RUN chmod +x /etc/service/apache2/run

#to add startup.sh to be runs the scripts during startup
RUN mkdir -p /etc/my_init.d
ADD startup.sh /etc/my_init.d/startup.sh
RUN chmod +x /etc/my_init.d/startup.sh

##internal fix that maybe
#refers to dockerfile_reference
#workaround for problem to modified /etc/hosts 
#replacing by /etc/workaround-docker-2267/hosts
#need to be execute commad each time upgrade modified libnss_files.so.2  (need to find a way to do this automatic)
RUN /usr/bin/workaround-docker-2267


#installing owncloud and creating database for it ....
ADD pre-conf.sh /pre-conf.sh
RUN chmod +x /pre-conf.sh
RUN /bin/bash -c /pre-conf.sh

# configuration file for owncloud and apache2
ADD apache2.conf /etc/apache2/apache2.conf
ADD owncloud.conf /etc/apache2/conf.d/owncloud.conf
ADD 000-default.conf /etc/apache2/sites-available/000-default.conf
ADD default-ssl.conf /etc/apache2/sites-available/default-ssl.conf
RUN mkdir -p /etc/apache2/ssl
RUN rm -R /var/www/html
RUN ( a2enmod ssl && a2enmod rewrite && a2enmod headers)

##scritp that can be running from the outside using docker-bash tool ...
#backup scritp with need to be use with VOLUME /var/backups/
ADD backup.sh /sbin/backup
RUN chmod +x /sbin/backup
VOLUME /var/backups

#expose port for https service
EXPOSE 443

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

#create Volume for the data for owncloud
VOLUME /var/www/owncloud/data
RUN chown -R www-data:www-data /var/www/owncloud


# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
