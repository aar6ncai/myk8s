#!/bin/bash
find . -type d -name ".svn"|xargs rm -rf
# DATE=`date +%y%m%d`
DATE=v0.2
docker build  --rm=true -t hub.linux100.cc/library/smtp:${DATE} .
