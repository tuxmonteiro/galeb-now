#!/bin/bash

if [ "$(uname)"  == "Darwin" -a -n "$DOCKER_HOST" ]; then
    ROUTER="$(echo $DOCKER_HOST | awk -F'[:/]' '{ print $4 }')"
else
    ROUTER="$(docker inspect galeb_router_1 | grep IPAddress | cut -d'"' -f4)"
fi

echo $ROUTER
