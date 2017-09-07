docker build --rm=true -t kcptun-socks5-ss-server:v3.0.8 .

https://github.com/EasyPi/docker-shadowsocks-libev
https://github.com/ZRStea/docker-shadowsocks-libev-obfs-privoxy
https://github.com/hangim/kcp-shadowsocks-docker

https://github.com/xtaci/kcptun/releases
https://github.com/dfdragon/kcptun_gclient

https://github.com/cndocker/kcptun-socks5-ss-server-docker
备注1：运行模式
* ss：提供shadowsocks-libev服务，SS对应端口“SS_SERVER_PORT”。
* kcptunss：提供kcptun & ss(手机ss客户端)服务，SS对应端口“SS_SERVER_PORT”、kcp端口对应“KCPTUN_SS_LISTEN”。
* kcptunsocks：提供kcptun & socks5（路由器kcptun插件）服务，kcptun & socks5服务的对应端口是“KCPTUN_LISTEN”。
* kcptunsocks-kcptunss：同时提供kcptun & socks5（路由器kcptun插件）与kcptun & ss(手机ss客户端)服务，
                        kcptun & socks5服务的对应端口是“KCPTUN_LISTEN”，
                        kcptun & ss服务的SS对应端口“SS_SERVER_PORT”、
                        kcp端口对应“KCPTUN_SS_LISTEN”。


# cat docker-compose.yml 
server:
  image: easypi/shadowsocks-libev
  ports:
    - "8388:8388/tcp"
    - "8388:8388/udp"
  environment:
    - METHOD=aes-256-cfb
    - PASSWORD=5ouMnqPyzseL
  restart: always



# cat docker-compose.yml 
server:
  image: easypi/shadowsocks-libev:obfs
  ports:
    - "8388:8388/tcp"
    - "8388:8388/udp"
  environment:
    - METHOD=aes-256-cfb
    - PASSWORD=5ouMnqPyzseL
  restart: always



# cat docker-compose.yml
server:
  image: imhang/kcp-shadowsocks-docker
  ports:
    - "443:443/tcp"
    - "443:443/udp"
    - "9443:9443/udp"
  environment:
    - SS_PORT=443
    - SS_PASSWORD=5ouMnqPyzseL
    - SS_METHOD=aes-256-cfb
    - SS_TIMEOUT=600
    - KCP_PORT=9443
    - KCP_KEY=5ouMnqPyzseL
    - KCP_CRYPT=none
    - KCP_MODE=fast
    - MTU=1400
    - SNDWND=1024
    - RCVWND=1024
  restart: always

![image](http://github.com/triumph/myk8s/raw/master/Dockerfile/10.S-S/kcptun.jpg)
