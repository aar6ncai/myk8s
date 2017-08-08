install:
kubectl apply -f 1.yaml
kubectl apply -f 2.yaml
kubectl apply -f 3.yaml

update:
kubectl set image deployment/jenkins jenkins=jenkinsci/jenkins:2.73 



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

https://raw.githubusercontent.com/triumph/myk8s/master/jenkins/k8s-jenkins_slave01.png
https://raw.githubusercontent.com/triumph/myk8s/master/jenkins/k8s-jenkins_slave02.png
https://raw.githubusercontent.com/triumph/myk8s/master/jenkins/k8s-jenkins_slave03.png
https://raw.githubusercontent.com/triumph/myk8s/master/jenkins/k8s-jenkins_slave04.png

4.Pipeline
# for git
podTemplate(name: "jnlp-slave") {
  node("jnlp-slave") {
    stage('拉取源码')
      checkout([$class: 'GitSCM', 
        branches: [[name: '*/master']], 
        doGenerateSubmoduleConfigurations: false, 
        extensions: [], 
        submoduleCfg: [], 
        userRemoteConfigs: [[url: 'https://github.com/triumph/CIJD.git']]])

    stage('准备环境变量')
      registry_addr = "hub.linux100.cc"
      registry_access = "1c0cf695-a284-459c-9f0c-a28c63dbf20d"
      maintainer_name = "library"
      container_name = "cijd"
      build_tag = sh(returnStdout: true, script: 'git rev-parse --short HEAD').trim()      

    container("jnlp") {
        stage("Build a Maven project")
          sh "mvn clean package"
      }

    stage('登入私用仓库')
      docker.withRegistry("https://${registry_addr}", "${registry_access}"){
        stage('Build 镜像')
          def NewApp = docker.build("${registry_addr}/${maintainer_name}/${container_name}:${build_tag}")
          echo "The Demo Image is ${registry_addr}/${maintainer_name}/${container_name}:${build_tag}"
        stage('Push 镜像')
          NewApp.push()
      }

    stage('删除本地 images')
      sh """
      docker rmi ${registry_addr}/${maintainer_name}/${container_name}:${build_tag}
      """
   
    stage('部署 yaml from k8s ')
      sh """
      sed -i "s/AAABBB/${build_tag}/g" k8s.yaml && kubectl --kubeconfig=/etc/kubeconfig apply -f k8s.yaml
      """
    stage('email 邮件通知') {
    emailext body: '''Project: $PROJECT_NAME 
    Build Number: # $BUILD_NUMBER
    Build Status: $BUILD_STATUS
    Check console output at $BUILD_URL to view the results.''', subject: '$BUILD_STATUS - $PROJECT_NAME - Build # $BUILD_NUMBER', to: 'yuxq@fabao.cn'
    }

  }
}


# for svn
podTemplate(name: "jnlp-slave") {
  node("jnlp-slave") {
    stage('拉取源码')
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
                           local: '.',  
                           remote: "http://10.252.163.79:8181/svn/DianZiQianZhang/trunk/java/signature"]],
              workspaceUpdater: [$class: 'UpdateUpdater']])

    stage('准备环境变量')
      registry_addr = "hub.linux100.cc"
      registry_access = "1c0cf695-a284-459c-9f0c-a28c63dbf20d"
      maintainer_name = "library"
      container_name = "signature"
      build_tag = sh(returnStdout: true, script: 'date +%s').trim()

    container("jnlp") {
      stage('Build a Maven project')
       sh " mvn clean package"

      stage('build and push 镜像')   
       sh "docker login -u=admin -p=Harbor12345 ${registry_addr}"
       sh "docker build -t ${registry_addr}/${maintainer_name}/${container_name}:${build_tag} ."

       sh "docker push ${registry_addr}/${maintainer_name}/${container_name}:${build_tag}"
       sh "docker rmi  ${registry_addr}/${maintainer_name}/${container_name}:${build_tag}"
    }
  }
}


# for svn 02
podTemplate(name: "jnlp-slave") {
  node("jnlp-slave") {
    stage('拉取源码')
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
                           local: '.', 
                           remote: "http://10.252.163.79:8181/svn/DianZiQianZhang/trunk/java/signature"]], 
              workspaceUpdater: [$class: 'UpdateWithCleanUpdater']])

    stage('准备环境变量')
      registry_addr = "hub.linux100.cc"
      registry_access = "1c0cf695-a284-459c-9f0c-a28c63dbf20d"
      maintainer_name = "library"
      container_name = "signature"
      build_tag = sh(returnStdout: true, script: 'date +%s').trim()

    container("jnlp") {
        stage("Build a Maven project")
          sh "mvn clean package"
      }

    stage('登入私用仓库')
      docker.withRegistry("http://${registry_addr}", "${registry_access}"){
        stage('Build 镜像')
          def NewApp = docker.build("${registry_addr}/${maintainer_name}/${container_name}:${build_tag}")
          echo "The Demo Image is ${registry_addr}/${maintainer_name}/${container_name}:${build_tag}"
        stage('Push 镜像')
          NewApp.push()
      }

    stage('delete build 镜像')
      sh """
      docker rmi ${registry_addr}/${maintainer_name}/${container_name}:${build_tag}
      """
  }
}




参考资料:
https://github.com/Starefossen/jenkins-k8s-demo

https://github.com/chenmiao2016/jenkins-slave-jnlp-docker

https://github.com/shuse2/docker-jnlp-slave-k8s

https://github.com/jaohaohsuan/jenkins-kubernetes

https://github.com/mugithi/jenkinsfile-k8s/blob/master/Jenkinsfile
https://github.com/jenkinsci/pipeline-examples/tree/master/jenkinsfile-examples/

https://wiki.shileizcc.com/display/KUB/Kubernetes+Pipeline

https://github.com/jenkinsci/kubernetes-plugin
https://issues.jenkins-ci.org/browse/JENKINS-42315

https://github.com/kingdonb/kube-mvn-svn-slave
