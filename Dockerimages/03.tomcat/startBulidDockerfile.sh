#!/bin/bash
find . -type d -name ".svn"|xargs rm -rf
# DATE=`date +%y%m%d`
DATE=8.5-jdk8
docker build  --rm=true -t hub.linux100.cc/library/tomcat:${DATE} .
