#!/bin/bash

rm -rf /tmp/galeb* || true

cd /tmp
git clone --recursive https://github.com/galeb/galeb-manager-webui.git
cd /tmp/galeb-manager-webui
rsync -avP --exclude=.git . /usr/share/nginx/html/
sed -i -e "s/\(http:\/\/\)localhost:8000/\1' + location.hostname + ':${MANAGER_PORT_8000_TCP_PORT}/" /usr/share/nginx/html/scripts/services/constants.js

/etc/init.d/nginx start
tail -f /var/log/nginx/*.log
