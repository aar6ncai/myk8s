#!/bin/bash
find . -type d -name ".svn"|xargs rm -rf
# DATE=`date +%y%m%d`
DATE=alpine-3.4
docker build  --rm=true -t hub.linux100.cc/library/base:${DATE} .
