#!/bin/bash

# Update nginx to match worker_processes to no. of cpu's
procs=$(npm -v)
sed -i -e "s/<%= npm_version %>/$procs/" /usr/share/nginx/html/views/index.ejs

# Always chown webroot for better mounting
chown -Rf nginx.nginx /usr/share/nginx/html
chmod -Rf 755 /usr/share/nginx/html

cd /usr/share/nginx/html && npm install

forever start app.js

# Start supervisord and services
/usr/bin/supervisord -n -c /etc/supervisord.conf
