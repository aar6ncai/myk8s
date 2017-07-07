ceph auth get-key client.admin

kubectl create secret generic ceph-secret-admin --from-literal=key='AQADMr1YXvIXHhAAoXSLnmgXhjHeXS01gEIQdg=='  --type=kubernetes.io/rbd  --namespace=kube-system

kubectl create secret generic ceph-secret-admin --from-literal=key='AQADMr1YXvIXHhAAoXSLnmgXhjHeXS01gEIQdg=='  --type=kubernetes.io/rbd  --namespace=default
