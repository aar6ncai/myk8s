FROM hub.linux100.cc/library/oracle-java:8-alpine
MAINTAINER triumph <triumph2008@gmail.com>

ENV CATALINA_HOME="/usr/local/tomcat" \
    PATH="/usr/local/tomcat/bin:$PATH" \
    TOMCAT_MAJOR_VERSION=8 \
    TOMCAT_MINOR_VERSION=8.5.16 \
    APACHE_MIRROR="http://mirror.bit.edu.cn/apache" \
    APR_VERSION=1.5.2 \
    TOMCAT_NATIVE_VERSION=1.2.8
RUN mkdir -p "${CATALINA_HOME}"
WORKDIR $CATALINA_HOME

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.ustc.edu.cn/g' /etc/apk/repositories

RUN set -x \
  && apk --no-cache add --virtual build-dependencies wget ca-certificates alpine-sdk gnupg \
  && update-ca-certificates \
  && wget -q --no-check-certificate "${APACHE_MIRROR}/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_MINOR_VERSION}/bin/apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz" \
  && wget -q --no-check-certificate "${APACHE_MIRROR}/tomcat/tomcat-${TOMCAT_MAJOR_VERSION}/v${TOMCAT_MINOR_VERSION}/bin/apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz.asc" \
  && gpg --verify "apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz.asc" \
  && tar -xf "apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz" --strip-components=1 \
  && rm bin/*.bat \
  && rm "apache-tomcat-${TOMCAT_MINOR_VERSION}.tar.gz" \
  && cd /tmp \
  && wget -q --no-check-certificate "${APACHE_MIRROR}/tomcat/tomcat-connectors/native/${TOMCAT_NATIVE_VERSION}/source/tomcat-native-${TOMCAT_NATIVE_VERSION}-src.tar.gz" \
  && wget -q --no-check-certificate "${APACHE_MIRROR}/apr/apr-${APR_VERSION}.tar.gz" \
  && tar -xf "apr-${APR_VERSION}.tar.gz" && cd "apr-${APR_VERSION}" && ./configure && make && make install \
  && cd /tmp && tar -xf "tomcat-native-${TOMCAT_NATIVE_VERSION}-src.tar.gz" && cd "tomcat-native-${TOMCAT_NATIVE_VERSION}-src/native" \
  && ./configure --with-apr="/usr/local/apr/bin" --with-java-home="$JAVA_HOME" --with-ssl=no --prefix="$CATALINA_HOME" \
  && make && make install \
  && ln -sv "${CATALINA_HOME}/lib/libtcnative-1.so" "/usr/lib/" && ln -sv "/lib/libz.so.1" "/usr/lib/libz.so.1" \
  && cd / \
  && rm -rf /tmp/* \
  && sed -i 's/SSLEngine="on"/SSLEngine="off"/g' "${CATALINA_HOME}/conf/server.xml" \
  && apk del --purge build-dependencies

EXPOSE 8080
CMD ["catalina.sh", "run"]
