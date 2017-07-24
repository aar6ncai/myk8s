FROM hub.linux100.cc/library/oracle-java:8-alpine
MAINTAINER triumph <triumph2008@gmail.com>

ENV JAVA_OPTS -Djava.security.egd=file:/dev/./urandom

EXPOSE 80
EXPOSE 8009

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories

RUN apk update && apk add --no-cache wget tzdata \
    && cp -r -f /usr/share/zoneinfo/Asia/Shanghai /etc/localtime  \
    && wget -q --no-check-certificate https://github.com/andreptb/smtp-server-for-it/releases/download/v0.2.0/smtp-server-for-it.jar -O smtp-server-for-it.jar \
    && apk del wget

CMD ["java", "-jar", "smtp-server-for-it.jar"]
