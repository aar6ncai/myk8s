k8s-docker-clean

DaemonSet to cleanup docker on k8s nodes.

Runs docker-clean.sh script every hour (default, you can change cron/root and rebuild image) which removes exited containers and dangling images/volumes.

This Pod runs in the kube-system namespace on every k8s node.

Deployment

kubectl --context CONTEXT -n kube-system apply -f deploy.yml



https://github.com/onfido/k8s-docker-clean
