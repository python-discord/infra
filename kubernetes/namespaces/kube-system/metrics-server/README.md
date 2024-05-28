# `metrics-server`

We deploy the Kubernetes Metrics Server from https://github.com/kubernetes-sigs/metrics-server

This service allows commands like `kubectl top` to return resource usage values
for nodes and pods in the cluster.

## Deployment

We use Helm for this deployment, the deployment steps are as follows:

``` sh
$ helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
$ helm upgrade -n kube-system --install metrics-server -f values.yaml metrics-server/metrics-server
```

You can validate a successful deployment by confirming that the following gives
a valid output:

``` sh
$ kubectl top nodes
```
