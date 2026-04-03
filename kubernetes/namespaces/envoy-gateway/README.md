# Gateway

We use Envoy Gateway as our Kubernetes Gateway API implementation (the successor to the deprecated Kubernetes Ingress API).

## Installation

Taken from https://gateway.envoyproxy.io/docs/tasks/quickstart/

```bash
$ helm install envoy-gateway oci://docker.io/envoyproxy/gateway-helm --version v1.7.1 -n envoy-gateway --create-namespace -f values.yaml
```

Wait for the `envoy-gateway` deployment to be ready:

```bash
$ kubectl wait --timeout=5m -n envoy-gateway deployment/envoy-gateway --for=condition=Available
```

Find the external IP address of the Envoy Gateway:

```bash
$ export GATEWAY_HOST=$(kubectl get gateway/envoy-gateway -o jsonpath='{.status.addresses[0].value}')
```

## Maintenance

You can install the `egctl` tool following instructions [here](https://gateway.envoyproxy.io/docs/install/install-egctl/) to manage the Envoy Gateway deployment.
