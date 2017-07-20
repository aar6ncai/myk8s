0.install nfs server
mkdir  -m 777 -p  /home/nfsshare/
yum -y install nfs-utils rpcbind
echo "/home/nfsshare/ *(rw,no_root_squash,no_all_squash,sync)"  > /etc/exports 
service rpcbind start ; service nfs start ; chkconfig rpcbind on ; chkconfig nfs on

groupadd -g 1000  jenkins  &&   useradd -u 1000 -g 1000 jenkins
mkdir -p /home/nfsshare/k8s/jenkins/home  && chown -R jenkins:jenkins  /home/nfsshare/k8s/jenkins/home


1.cat  /var/jenkins_home/secrets/initialAdminPassword
nfs  (/home/nfsshare/k8s/jenkins/home/secrets/initialAdminPassword)


2.jenkins-系统管理-系统设置-云-Kubernetes:
Name: k8s_cluster
Kubernetes URL: http://192.168.28.193:8080
Kubernetes Namespace: default
Jenkins URL: http://jenkins.default:8080

images - Kubernetes Pod Template:
Name: jnlp-slave
Labels: jnlp-slave
Container Template Name: jnlp
Docker image: jenkinsci/jnlp-slave:2.62
Jenkins slave root directory: /home/jenkins


3.k8s nodes jnlp-slave
mkdir /home/jenkins


4.Pipeline
# for git
podTemplate(name: "jnlp-slave") {
  node("jnlp-slave") {
    stage 'Get a Maven project'
    git 'https://github.com/silvasong/CIJD.git'
    container("jnlp") {
      stage 'Build a Maven project'
      sh 'mvn clean package'
      }
  }
}


# for svn
podTemplate(name: "jnlp-slave") {
  node("jnlp-slave") {
    stage 'svn checkout'
    checkout([$class: 'SubversionSCM', 
              additionalCredentials: [], 
              excludedCommitMessages: '', 
              excludedRegions: '', 
              excludedRevprop: '', 
              excludedUsers: '', 
              filterChangelog: false, 
              ignoreDirPropChanges: false, 
              includedRegions: '', 
              locations: [[credentialsId: '0e8b367a-ec0a-4842-a846-f795b36ca7fb', 
                           depthOption: 'infinity', 
                           ignoreExternalsOption: true, 
                           local: 'src', 
                           remote: "http://10.252.163.79:8181/svn/DianZiQianZhang/trunk/java/signature"]], 
              workspaceUpdater: [$class: 'UpdateUpdater']])
    container("jnlp") {
       stage 'Build a Maven project'
       sh """
       cd src && mvn clean package && cd ..
       wget -O Dockerfile http://monitor.xxxxx.cn:8888/zabbix_soft/k8s_JAVA_signature_Dockerfile
       docker build -t hub.linux100.cc/library/signature:2017072002 .
       docker login -u=admin -p=Harbor12345 hub.linux100.cc
       docker push hub.linux100.cc/library/signature:2017072002
       docker rmi  hub.linux100.cc/library/signature:2017072002
       """
      }
  }
}





参考资料:
https://github.com/Starefossen/jenkins-k8s-demo

https://github.com/chenmiao2016/jenkins-slave-jnlp-docker

https://github.com/shuse2/docker-jnlp-slave-k8s

https://github.com/jaohaohsuan/jenkins-kubernetes

https://github.com/mugithi/jenkinsfile-k8s/blob/master/Jenkinsfile

https://wiki.shileizcc.com/display/KUB/Kubernetes+Pipeline

https://github.com/jenkinsci/kubernetes-plugin
https://issues.jenkins-ci.org/browse/JENKINS-42315

https://github.com/kingdonb/kube-mvn-svn-slave
