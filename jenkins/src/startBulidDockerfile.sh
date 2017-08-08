#!/bin/bash
find . -type d -name ".svn"|xargs rm -rf
# DATE=`date +%y%m%d`
DATE=170721
docker build  --rm=true -t jenkins_slave_jnlp:${DATE} .
