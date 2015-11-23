#!/bin/bash

rm -rf galeb3* || true

git clone --recursive https://github.com/galeb/galeb3-router.git
cd galeb3-router
mvn clean install
cp /tmp/log4j.xml .
cp /tmp/hazelcast.xml .

sed -i "s/%CLUSTER_ID%/$CLUSTER_ID/" hazelcast.xml

java -server \
     -Xbootclasspath/p:target/alpn.jar \
     -Xms1024m \
     -Xmx1024m \
     -Dlog4j.configurationFile=log4j.xml \
     -Dhazelcast.config=hazelcast.xml \
     -Dio.galeb.services.router.port=$PORT \
     -Dio.galeb.maxConn=$MAXCONN \
     -Dio.galeb.schedulerInterval=$INTERVAL \
     -Dio.galeb.pool.softMaxConnectionsPerThread=5 \
     -Dio.galeb.services.router.idleTimeout=30000 \
     -Dio.galeb.core.statsd.host=127.0.0.1 \
     -Dio.galeb.core.statsd.port=8125 \
     -Dio.galeb.cmm.ttl.threadId=3600 \
     -Dio.galeb.cmm.ttl.uri=3600 \
     -jar target/galeb-router-$VERSION-uber.jar
