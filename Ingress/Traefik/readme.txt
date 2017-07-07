1.edgenode节点 keepalived VIP设置


2.edgenode节点 label设置
kubectl label nodes 172.20.0.113 edgenode=true
kubectl label nodes 172.20.0.114 edgenode=true
kubectl label nodes 172.20.0.115 edgenode=true


3.traefik-ingress-DaemonSet 发布
