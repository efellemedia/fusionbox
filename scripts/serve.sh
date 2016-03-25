#!/usr/bin/env bash

block="<VirtualHost *:80>
    ServerName $1
    DocumentRoot $2

    <Directory />
        Options FollowSymLinks
        AllowOverride All
    </Directory>

    <Directory $2/>
        Options Indexes FollowSymLinks MultiViews
        AllowOverride All
        Order allow,deny
        allow from All
    </Directory>
</VirtualHost>"

echo "$block" >> /etc/httpd/sites-available/$1.conf
ln -s /etc/httpd/sites-available/$1.conf /etc/httpd/sites-enabled/$1.conf

service httpd configtest
service httpd restart
