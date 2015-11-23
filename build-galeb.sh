#!/bin/bash

curdir=$PWD
VERSION=3.1.9

for i in galeb-api galeb-healthchecker galeb-router galeb-metrics backend-galeb-test
do
    cd $i
    pwd
    IMAGE="galeb/${i}"
    ID="$(docker build -t ${IMAGE} .)"
    docker tag ${ID} ${IMAGE}:${VERSION}
    docker tag -f ${ID} ${IMAGE}:latest
    cd $curdir
done
