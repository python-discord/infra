# NGINX Gateway Fabric

We use NGINX Gateway Fabric to manage our ingress traffic. This replaced the previous NGINX Ingress Controller which is no longer maintained.

## Installation

## Pre-requisites

1. Apply `namespace.yaml` to create the `nginx-gateway` namespace.
2. Apply certificates in `certificates.yaml` to create the necessary TLS secrets.
3. Apply `client-certs.yaml` to create client certificates for secure communication between NGINX control & data plane.
4. Apply resources in `mtls/` using `make all` to create the mTLS origin pull CA secret.

## Helm Installation of Gateway Fabric control plane

1. Create NGINX CRDs with `kubectl kustomize "https://github.com/nginx/nginx-gateway-fabric/config/crd/gateway-api/standard?ref=v2.5.1" | kubectl apply -f -`
2. Run `helm install ngf oci://ghcr.io/nginx/charts/nginx-gateway-fabric --create-namespace -n nginx-gateway -f values.yaml` to install NGINX Gateway Fabric using Helm.
3. Wait for the installation to complete with `kubectl wait --timeout=5m -n nginx-gateway deployment/ngf-nginx-gateway-fabric --for=condition=Available`

NOTE: To upgrade/change values, switch from `helm install` to `helm upgrade`.

## Creation of Gateway & associated resources

1. Apply `gateway.yaml` to create the Gateway resource that defines how ingress traffic should be routed to services in the cluster.
2. Apply `reference-grants.yaml` to create ReferenceGrant resources that allow the Gateway to reference services in other namespaces.
3. Apply snippets in `snippets/` to create reusable configuration snippets for use in HTTPRoute resources (notably mTLS enforcement).
4. Finally, create routes from `routes/special/` and `routes/service-routes/` to define how traffic should be routed to services in the cluster.
