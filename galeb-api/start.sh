#!/bin/bash

rm -rf galeb* || true

git clone --recursive https://github.com/galeb/galeb-api.git
cd galeb-api
mvn clean install
cp /tmp/log4j.xml .
cp /tmp/hazelcast.xml .

sed -i "s/%CLUSTER_ID%/$CLUSTER_ID/" hazelcast.xml

java -server \
     -Xms1024m \
     -Xmx1024m \
     -Dlog4j.configurationFile=log4j.xml \
     -Dhazelcast.config=hazelcast.xml \
     -Dio.galeb.services.api.port=$PORT \
     -Dio.galeb.services.api.queue.limit=1048576 \
     -jar target/galeb-api-$VERSION-uber.jar
