#! /bin/bash

yum update -y

yum install httpd -y

service httpd start

chkconfig httpd on

echo "<h1>Response from webserver </h1>" > /var/www/html/index.html