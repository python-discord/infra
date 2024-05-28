# Kubernetes System Namespace

The `kube-system` namespace contains several services used for the operation of
the Kubernetes cluster.

## Folder Contents

### `coredns-custom.yaml`

This is a custom CoreDNS configuration file loaded in by Linode allowing us to
add additional configuration options to our cluster DNS server, such as
additional logging of specific queries.

### `nginx`

This folder contains the deployment of the `ingress-nginx` service which handles
all inbound traffic to the cluster, TLS termination and forwarding to the
relevant internal services.

### `reflector`

This is a system component which allows specific annotations on secrets to
trigger them to replicate to a selected set of other namespaces.

See the README.md in the folder for more information.

## Other components

We deploy the Kubernetes [`metrics-server`](https://github.com/kubernetes-sigs/metrics-server) using the
manifests specified in the project repository. This allows commands like
`kubectl top` to work.

We also deploy [`kube-state-metrics`](https://github.com/kubernetes/kube-state-metrics) again using the manifests located in the repository.
