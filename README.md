docker-owncloud
================

Owncloud 7 running on docker(lxc) container ..
It will be update to the last version of the official release 


To run the container ...

docker run -d -p 443:443 -e C=US
-e ST=California
-e L=Sacramento
-e O=example
-e OU=IT_Deparment
-e CN=example.com
quantumobject/docker-owncloud



The -e is to give info for the SSL generation of .key and .pem file ... please change the values for your specific location and info ... 

Check port and point your brownser to https://[ip]:443/ and log in with: admin  plus create your own password. 

To access the container from the server that the container is running :

docker exec -it container_id /bin/bash


for more info for owncloud check :

http://doc.owncloud.org/

