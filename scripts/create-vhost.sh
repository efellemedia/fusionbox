#!/usr/bin/env bash

block="<VirtualHost *:80>
    ServerName $1
    DocumentRoot "$2"
    AccessFileName .htaccess.local .htaccess

    <Directory "$2">
        Options FollowSymLinks Indexes
        AllowOverride All
        Order allow,deny
        Allow from all
    </Directory>
</VirtualHost>"

echo "$block" >> /etc/httpd/sites-available/$1.conf
ln -s /etc/httpd/sites-available/$1.conf /etc/httpd/sites-enabled/$1.conf

service httpd configtest
service httpd restart
