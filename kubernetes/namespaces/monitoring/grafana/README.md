# Grafana

This folder contains the manifests for deploying our Grafana instance, the service we use to query our data.

This deployment expects a number of secrets and environment variables to exist in a secret called `grafana-secret-env`.

| Environment                  | Description                                         |
|------------------------------|-----------------------------------------------------|
| GF_AUTH_GITHUB_CLIENT_ID     | The client ID of the Github app to use for auth     |
| GF_AUTH_GITHUB_CLIENT_SECRET | The client secret of the Github app to use for auth |
| GF_SECURITY_ADMIN_PASSWORD   | The admin password the the grafana admin console    |
