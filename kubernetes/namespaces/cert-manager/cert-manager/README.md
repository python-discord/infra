# cert-manager

X.509 certificate management for Kubernetes.

> cert-manager builds on top of Kubernetes, introducing certificate authorities and certificates as first-class resource types in the Kubernetes API. This makes it possible to provide to developers 'certificates as a service' in your Kubernetes cluster.

We install cert-manager through [Helm using this guide](https://cert-manager.io/docs/installation/kubernetes/#installing-with-helm).

## Directories

`issuers`: Contains configured issuers, right now only letsencrypt production & staging.

`certificates`: Contains TLS certificates that should be provisioned and where they should be stored.
