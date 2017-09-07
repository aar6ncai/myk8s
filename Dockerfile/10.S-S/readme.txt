docker build --rm=true -t kcptun-socks5-ss-server:v3.0.8 .

docker run -ti --name=kcptun-socks5-ss-server \
-p 8388:8388 \
-p 8388:8388/udp \
-p 34567:34567/udp \
-p 45678:45678/udp \
-e SS_SERVER_ADDR=0.0.0.0 \
-e SS_SERVER_PORT=8388 \
-e SS_PASSWORD=5ouMnqPyzseL \
-e SS_METHOD=aes-256-cfb \
-e SS_DNS_ADDR=8.8.8.8 \
-e SS_UDP=true \
-e SS_ONETIME_AUTH=true \
-e SS_FAST_OPEN=true \
-e KCPTUN_LISTEN=45678 \
-e KCPTUN_SS_LISTEN=34567 \
-e KCPTUN_SOCKS5_PORT=12948 \
-e KCPTUN_KEY=5ouMnqPyzseL \
-e KCPTUN_CRYPT=aes \
-e KCPTUN_MODE=fast2 \
-e KCPTUN_MTU=1350 \
-e KCPTUN_SNDWND=1024 \
-e KCPTUN_RCVWND=1024 \
-e KCPTUN_NOCOMP=false \
-e RUNENV=kcptunsocks-kcptunss \
kcptun-socks5-ss-server:v3.0.8


###备注1：运行模式 
* kcptunsocks-kcptunss：同时提供kcptun & socks5（路由器kcptun插件）与kcptun & ss(手机ss客户端)服务，kcptun & socks5服务的对应端口是“KCPTUN_LISTEN”，kcptun & ss服务的SS对应端口“SS_SERVER_PORT”、kcp端口对应“KCPTUN_SS_LISTEN”。
* kcptunsocks：提供kcptun & socks5（路由器kcptun插件）服务，kcptun & socks5服务的对应端口是“KCPTUN_LISTEN”。 
* kcptunss：提供kcptun & ss(手机ss客户端)服务，SS对应端口“SS_SERVER_PORT”、kcp端口对应“KCPTUN_SS_LISTEN”。 
* ss：提供shadowsocks-libev服务，SS对应端口“SS_SERVER_PORT”。


https://github.com/cndocker/kcptun-socks5-ss-server-docker
https://github.com/EasyPi/docker-shadowsocks-libev
https://github.com/ZRStea/docker-shadowsocks-libev-obfs-privoxy


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
