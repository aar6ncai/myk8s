# step 1: 安装必要的一些系统工具
sudo yum install -y yum-utils device-mapper-persistent-data lvm2 lsof mailcap

# Step 2: 添加软件源信息
sudo yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo

# Step 3: 更新并安装 Docker-CE
sudo yum makecache fast
sudo yum -y install docker-ce

# Step 4: 添加 registry-mirrors
sudo cat << EOF  > /etc/docker/daemon.json 
{
    "registry-mirrors": ["https://ney1sxt7.mirror.aliyuncs.com"],
    "live-restore": true
}
EOF

# Step 5: 开启Docker服务
sudo sed -i "s/#Port 22/Port 22332/g" /etc/ssh/sshd_config && sudo systemctl restart sshd
sudo systemctl start docker

# Step 6: 开机启动Docker服务
sudo systemctl enable docker

# Step 7: 安装 docker-compose
sudo wget -O  /usr/bin/docker-compose http://mirrors.aliyun.com/docker-toolbox/linux/compose/1.9.0/docker-compose-Linux-x86_64
sudo chmod +x /usr/bin/docker-compose

# Step 8: 安装 gitlab-ce-zh
sudo mkdir -p gitlab-ce-zh && cd gitlab-ce-zh && wget https://raw.githubusercontent.com/twang2218/gitlab-ce-zh/master/docker-compose.yml
sudo vim docker-compose.yml
sudo docker-compose up -d
sudo docker-compose stop

# Step 9: 安装 ownCloud
sudo mkdir -p ownCloud && cd ownCloud && wget https://raw.githubusercontent.com/triumph/myk8s/master/ownCloud/docker-compose.yml
sudo vim docker-compose.yml

sudo useradd -u 999 mysql 
sudo useradd -u 33  www-data
sudo groupadd -g 65534 nogroup
sudo mkdir -p ownData
sudo yum install -y https://github.com/aliyun/ossfs/releases/download/v1.80.2/ossfs_1.80.2_centos7.0_x86_64.rpm
sudo ln -s /usr/local/bin/ossfs  /bin/ossfs
sudo echo my-bucket:my-access-key-id:my-access-key-secret > /etc/passwd-ossfs && chmod 640 /etc/passwd-ossfs
sudo ossfs my-bucket /root/ownCloud/ownData  -ourl=http://oss-cn-hangzhou-internal.aliyuncs.com -ouid=33 -ogid=65534 -o allow_other -o umask=007 -o max_stat_cache_size=0


sudo docker-compose up -d
sudo docker-compose stop

sudo fusermount -u /root/ownCloud/ownData
sudo ossfs my-bucket /root/ownCloud/ownData  -ourl=http://oss-cn-hangzhou-internal.aliyuncs.com -ouid=33 -ogid=65534 -o allow_other -o umask=007
