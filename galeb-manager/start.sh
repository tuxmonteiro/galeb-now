#!/bin/bash

rm -rf galeb* || true

git clone --recursive https://github.com/galeb/galeb-manager.git
git fetch --all
git checkout $VERSION
cd galeb-manager
mvn clean install -DskipTests
cp /tmp/log4j.xml .

export GALEB_DB_URL=jdbc:mysql://$DB_PORT_3306_TCP_ADDR/galeb
export GALEB_DB_USER=root
export GALEB_DB_PASS=password
export REDIS_HOSTNAME=$REDIS_PORT_6379_TCP_ADDR
export REDIS_PORT=$REDIS_PORT_6379_TCP_PORT

java -server \
     -Xms2048m \
     -Xmx2048m \
     -Dlog4j.configurationFile=log4j.xml \
     -Dauth_method=DEFAULT \
     -Dserver.port=$PORT \
     -DINTERNAL_PASSWORD=password \
     -jar target/galeb-manager-$VERSION.jar
