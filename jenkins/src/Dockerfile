FROM andreptb/oracle-java:8-alpine

MAINTAINER triumph2008 <triumph2008@gmail.com>

ENV MAVEN_VERSION 3.3.9
ENV MAVEN_HOME /usr/lib/maven
ENV PATH /usr/lib/maven/bin:$JAVA_HOME/bin:$PATH

RUN apk update && \
    apk add curl bash tree tzdata wget git subversion python python-dev py-pip mysql-dev build-base && \
    cp -r -f /usr/share/zoneinfo/Hongkong /etc/localtime && \
    cd /tmp && \
    wget -q http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz -O - | tar xzf - && \
    mv /tmp/apache-maven-$MAVEN_VERSION /usr/lib/maven && \
    ln -s /usr/lib/maven/bin/mvn /usr/bin/mvn && \
    rm -rf /tmp/apache-maven* && \
    mkdir -m 777 -p /usr/local/repository && \
    mkdir -m 777 -p /usr/local/pkg

COPY docker  /bin/docker
COPY kubectl /bin/kubectl
COPY settings.xml /usr/lib/maven/conf/settings.xml

ENV JENKINS_REMOTING_VERSION 2.62

RUN /usr/bin/curl --create-dirs -sSLo /usr/share/jenkins/remoting-$JENKINS_REMOTING_VERSION.jar http://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/$JENKINS_REMOTING_VERSION/remoting-$JENKINS_REMOTING_VERSION.jar \
  && chmod 755 /usr/share/jenkins

COPY jenkins-slave.sh /usr/local/bin/jenkins-slave.sh

ENTRYPOINT ["/usr/local/bin/jenkins-slave.sh"]





