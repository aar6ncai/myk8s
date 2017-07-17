openssl req  -newkey rsa:2048 -nodes -keyout tls.key  -x509 -days 365 -out tls.crt

kubectl create secret generic tls-secret --from-file=tls.crt --from-file=tls.key -n kube-system

kubectl create configmap haproxy-ingress -n kube-system

kubectl apply -f 10.default-backend.yaml

kubectl apply -f 20.haproxy-ingress-controller-rbac.yml

kubectl apply -f 21.haproxy-ingress-daemonset.yaml

kubectl apply -f 30.nginx-web-example.yaml
