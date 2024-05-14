# Kubernetes reflector

We use [kubernetes-reflector](github.com/emberstack/kubernetes-reflector) to mirror certificate resources into all namespaces that need access to the wildcard certificates used for the cluster.

It is deployed using Helm with no additional configuration using the following steps:

``` sh
$ helm repo add emberstack https://emberstack.github.io/helm-charts
$ helm repo update
$ helm upgrade -n kube-system --install reflector emberstack/reflector
```
