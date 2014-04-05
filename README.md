docker-owncloud6
================

Owncloud 6 running on docker(lxc) container ..



To run the container ...

docker run -d -p 22 -p 443 -e C = US
-e ST = California
-e L = Sacramento
-e O = example
-e OU = IT Deparment
-e CN = example.com
angelrr7702/docker-owncloud6



The -e is to give info for the SSL generation of .key and .pem file ... please change the values for your specific location and info ... 

check port and point your brownser to location ...and log in with: admin admin , remember to use mysql database with database name: owncloud and password: ownclouddbpasswd plus server will be: localhost ... and user will be : ownclouduser

for ssh access login : root password: rootprovisonal ==> replace password when using it with passwd command

