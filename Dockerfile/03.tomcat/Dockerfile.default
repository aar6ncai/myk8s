FROM andreptb/tomcat:8.5-jdk8
MAINTAINER triumph <triumph2008@gmail.com>

RUN apk add  --no-cache tzdata  && \
    cp -r -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime  && \
    echo "export LANG=C.UTF-8" > /etc/profile.d/locale.sh 
