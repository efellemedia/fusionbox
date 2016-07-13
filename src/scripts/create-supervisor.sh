#!/usr/bin/env bash

mkdir -p /etc/supervisor

block="[program:$1]
command=$2
directory=$3
stdout_logfile=$4
redirect_stderr=true
autostart=true
autorestart=true"

echo "$block" >> /etc/supervisor/$1.conf

supervisorctl reread
supervisorctl add $1
supervisorctl start $1
