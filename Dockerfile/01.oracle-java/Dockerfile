FROM andreptb/oracle-java:8-alpine
MAINTAINER triumph <triumph2008@gmail.com>

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories

RUN apk add  --no-cache tzdata  && \
    cp -r -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime  && \
    echo "export LANG=C.UTF-8" > /etc/profile.d/locale.sh 
