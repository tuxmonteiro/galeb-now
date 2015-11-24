#!/bin/bash

rm -rf galeb* || true

git clone --recursive https://github.com/galeb/galeb-manager.git
cd galeb-manager
git fetch --all
git checkout $VERSION
mvn clean install -DskipTests
cp /tmp/log4j.xml .

export GALEB_DB_URL=jdbc:mysql://$DB_PORT_3306_TCP_ADDR/galeb
export GALEB_DB_USER=root
export GALEB_DB_PASS=password
export REDIS_HOSTNAME=$REDIS_PORT_6379_TCP_ADDR
export REDIS_PORT=$REDIS_PORT_6379_TCP_PORT

sed -i -e "s/NGINX_PORT/${NGINX_PORT}/g" /tmp/nginx.conf
sed -i -e "s/MANAGER_PORT/${PORT}/g" /tmp/nginx.conf
cat /tmp/nginx.conf > /etc/nginx/nginx.conf
/etc/init.d/nginx restart

API="localhost:9090"
sed -i -e "s/MANAGER_PORT/${PORT}/" /tmp/load-farm.sh
if [ "x${API_PORT}" != "x" ]; then
    API="$(echo ${API_PORT} | sed 's/tcp:\/\///')"
    sed -i -e "s/API_ADDR_AND_PORT/${API}/" /tmp/load-farm.sh
    (while [ $(curl --output /dev/null --silent --head --fail http://localhost:${PORT}; echo $?) -gt 7 ]; do printf '.'; sleep 5; done; /tmp/load-farm.sh)&
fi

java -server \
     -Xms2048m \
     -Xmx2048m \
     -Dlog4j.configurationFile=log4j.xml \
     -Dauth_method=DEFAULT \
     -Dserver.port=$PORT \
     -Dserver.address=127.0.0.1 \
     -DINTERNAL_PASSWORD=password \
     -jar target/galeb-manager-$VERSION.jar
