#!/usr/bin/env bash

service httpd configtest
service httpd restart

chkconfig beanstalkd on
