#!/bin/bash


source /etc/profile

if [[ ! -n $1 ]] || [[ ! -n $2 ]];then
        echo '参数1,2不能为空！,分别代表实例名和war包下载地址！！'
        exit   1
fi

ip=`ifconfig eth0 |grep "inet addr"| cut -f 2 -d ":"|cut -f 1 -d " "`
filename=`echo $2 | awk -F "/"  '{print $NF}'`

pj=$1
pjs=(CSPT_JAVA_overdue_core CSPT_JAVA_overdue_manager CSPT_java_openapi)

URL=$2


for i in ${pjs[@]}
do
        if [ $pj = $i ];then
                prj=$pj
                break
        fi
done

if [ ! "$prj" ];then
        echo "实例名称输入错误，本脚本的两个参数分别代表实例名称和下载URL地址！"
        exit  1
fi


case $prj in
"P_SRV_ReportCronMessage")
       echo  "ok123"

;;
"CSPT_JAVA_overdue_core")
      cd   /services/module/apache-tomcat-7.0.75_core/
      service  tomcat-overdue_core_srv  stop
      sleep 1
      /bin/rm   -rf   /services/module/apache-tomcat-7.0.75_core/webapps/overdue-core
      /bin/find    /services/module/apache-tomcat-7.0.75_core/webapps/    -type f -name "*.war" -exec rm -fr {} \;
      /usr/bin/wget --quiet   $URL  -O    /services/module/apache-tomcat-7.0.75_core/webapps/overdue-core.war
      sleep 5
      service  tomcat-overdue_core_srv  start
      sleep 30
      if [ `ps -ef | grep  apache-tomcat-7.0.75_core | grep -v grep | wc -l` -eq "1" ]
        then
        echo  "ok123"
      else
        echo  "flase123"
        exit 1
      fi
;;
"CSPT_JAVA_overdue_manager")
      cd   /services/module/apache-tomcat-7.0.75_manager/
      service  tomcat-overdue_manager_srv  stop
      sleep 1
      /bin/rm   -rf   /services/module/apache-tomcat-7.0.75_manager/webapps/ROOT
      /bin/find    /services/module/apache-tomcat-7.0.75_manager/webapps/    -type f -name "*.war" -exec rm -fr {} \;
      /usr/bin/wget --quiet   $URL  -O    /services/module/apache-tomcat-7.0.75_manager/webapps/ROOT.war
      sleep 5
      service  tomcat-overdue_manager_srv  start
      sleep 30
      if [ `ps -ef | grep  apache-tomcat-7.0.75_manager | grep -v grep | wc -l` -eq "1" ]
        then
        echo  "ok123"
      else
        echo  "flase123"
        exit 1
      fi
;;
"CSPT_java_openapi")
      cd   /services/srv/openapi_srv/
      /usr/bin/wget --quiet  $URL  && /usr/bin/supervisorctl stop openapi  && /bin/rm -f openapi-last.jar
      sleep 5
      ln -s $filename openapi-last.jar && /usr/bin/supervisorctl start openapi
      sleep 30
      if [ `ps -ef | grep -v grep | grep -c  openapi_srv` -eq "1" ]
        then
        echo  "ok123"
      else
        echo  "flase123"
        exit 1
      fi
;;
*)
        echo "脚本他娘的问题了，ERROR $3..."
esac
