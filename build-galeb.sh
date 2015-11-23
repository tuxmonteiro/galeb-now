#!/bin/bash

curdir=$PWD
VERSION=3.1.9

for i in galeb-api galeb-healthchecker galeb-router galeb-metrics backend-galeb-test galeb-manager galeb-manager-webui
do
    cd $i
    pwd
    IMAGE="galeb/${i}"
    docker build -t ${IMAGE} .
    cd $curdir
done
