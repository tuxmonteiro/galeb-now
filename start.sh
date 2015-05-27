#!/bin/bash

cd galeb && docker-compose up -d
cd - > /dev/null 2>&1
echo
echo '================================'
echo "> Building.... (wait until 150 seconds)"
for x in $(seq 1 150); do echo -n '.';sleep 1;done; echo
echo '================================'
echo "> Loading routes...."
./load-routes.sh
echo '================================'
echo "> DONE. Executing curl -H'Host: lol.localdomain' $(./ip-router.sh):8080"
sleep 2
curl -H'Host: lol.localdomain' $(./ip-router.sh):8080
