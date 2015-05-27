#!/bin/bash

curdir=$PWD

for i in galeb-api galeb-healthchecker galeb-router galeb-metrics backend-galeb-test
do
    cd $i
    docker build -t galeb/$i .
    cd $curdir
done
