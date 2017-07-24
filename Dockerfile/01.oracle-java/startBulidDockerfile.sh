#!/bin/bash
find . -type d -name ".svn"|xargs rm -rf
# DATE=`date +%y%m%d`
DATE=8-alpine
docker build  --rm=true -t hub.linux100.cc/library/oracle-java:${DATE} .
