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




参考资料:
https://github.com/Starefossen/jenkins-k8s-demo

https://github.com/shuse2/docker-jnlp-slave-k8s

https://github.com/mugithi/jenkinsfile-k8s/blob/master/Jenkinsfile

https://github.com/jaohaohsuan/jenkins-kubernetes

https://github.com/kingdonb/kube-mvn-svn-slave

https://github.com/chenmiao2016/jenkins-slave-jnlp-docker

https://wiki.shileizcc.com/display/KUB/Kubernetes+Pipeline
