# Tailscale

We use the Tailscale Kubernetes Operator to allow in-cluster services to connect securely to external services via a secure tunnel.

## Deployment

1. Add the Helm chart `helm repo add tailscale https://pkgs.tailscale.com/helmcharts`
2. Update the Helm repo `helm repo update`
3. Install the tailscale operator, replacing OAuth credentials as necessary (from the Trust credentials section of Tailscale admin console):
    ```bash
    helm upgrade \
    --install \
    tailscale-operator \
    tailscale/tailscale-operator \
    --namespace=tailscale \
    --create-namespace \
    --set-string oauth.clientId="<OAauth client ID>" \
    --set-string oauth.clientSecret="<OAuth client secret>" \
    --wait
    ```
