#!/bin/bash
find . -type d -name ".svn"|xargs rm -rf
# DATE=`date +%y%m%d`
DATE=170720
docker build  --rm=true -t jenkins_slave_jnlp:${DATE} .
