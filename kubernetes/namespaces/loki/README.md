# Logging

We deploy multiple components through Helm to solve logging within our cluster.

## Loki

We use `loki_values.yml` to deploy the `grafana/loki` Helm chart.

Once this is deployed, the service `loki-gateway.loki.svc.cluster.local` will point to one of the Loki replicas.

```
$ helm repo add grafana https://grafana.github.io/helm-charts
$ helm repo update
$ helm upgrade --install -n loki --values loki_values.yml loki grafana/loki
```

## Alloy

[Alloy](https://grafana.com/oss/alloy-opentelemetry-collector/) ships logs from all pods through to Loki.

This requires no additional configuration, just make sure Loki is up and Alloy will start shipping logs.

```
$ helm upgrade --install -n loki --values alloy_values.yml alloy grafana/alloy
```
