kubectl version | base64 | tr -d '\n'

kubectl -n kube-system apply -f 10.scope.yaml
kubectl -n kube-system apply -f 20.web.yaml

kubectl  get ing


kubectl apply -n kube-system -f \
   "https://cloud.weave.works/k8s.yaml?t=pwfihfgfbx1613qmuu1yuw6hsyajks66&k8s-version=$(kubectl version | base64 | tr -d '\n')"
