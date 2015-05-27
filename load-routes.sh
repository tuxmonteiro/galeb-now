#!/bin/bash

if [ $# -ge 2 ]; then
    POLICY=$2
else
    POLICY="default"
fi

case $POLICY in
    "rr")
        POLICY="RoundRobin"
        ;;
    "rd")
        POLICY="Random"
        ;;
    "hash")
        POLICY="IPHash"
        ;;
    "lc")
        POLICY="LeastConn"
        ;;
esac

if [ "$(uname)"  == "Darwin" -a -n "$DOCKER_HOST" ]; then
    API="$(echo $DOCKER_HOST | awk -F'[:/]' '{ print $4 }')"
    BACKEND1=$API
    BACKEND2=$API
    BACKEND3=$API
    BACKEND4=$API
else
    API="$(docker inspect galeb_api_1 | grep IPAddress | cut -d'"' -f4)"
    BACKEND1="$(docker inspect galeb_backend1_1 | grep IPAddress | cut -d'"' -f4)"
    BACKEND2="$(docker inspect galeb_backend2_1 | grep IPAddress | cut -d'"' -f4)"
    BACKEND3="$(docker inspect galeb_backend3_1 | grep IPAddress | cut -d'"' -f4)"
    BACKEND4="$(docker inspect galeb_backend4_1 | grep IPAddress | cut -d'"' -f4)"
fi

sed -e "s/@POLICY@/$POLICY/g" -e "s/@BACKEND1@/$BACKEND1/g" -e "s/@BACKEND2@/$BACKEND2/g" -e "s/@BACKEND3@/$BACKEND3/g" -e "s/@BACKEND4@/$BACKEND4/g" -e "s/@API@/$API/g" routes.template > routes.sh
chmod +x routes.sh
./routes.sh

rm -f routes.sh
