# Vault

We deploy an instance of [HashiCorp
Vault](https://developer.hashicorp.com/vault) to store various types of secret
data used on the cluster.

We use it to issue X509 certificates for mutual TLS setups.

As well as this, the Helm chart used allows for secret injection based on the
annotations present in pods deployed to the cluster. See more
[here](https://developer.hashicorp.com/vault/docs/platform/k8s/injector)

# Setup

1. Add the Helm repository for HashiCorp:

``` sh
$ helm repo add hashicorp https://helm.releases.hashicorp.com
"hashicorp" has been added to your repositories
```

2. Install Vault to the `vault` namespace using the following command:

``` sh
$ helm install --create-namespace vault hashicorp/vault --namespace vault
...
```

3. Voila, Vault is deployed in the `vault` namespace.
