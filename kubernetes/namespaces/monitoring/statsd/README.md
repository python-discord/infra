# StatsD Exporter

We used to use a StatsD/Graphite stack for monitoring, but it was fairly bad and had a whole additional volume required.

We have decided to standardise on Prometheus for best-effort monitoring and use the StatsD Exporter to convert StatsD metrics to Prometheus format. This allows us to continue using our existing StatsD instrumentation without needing to maintain a separate monitoring stack.

## Components

- `deployment.yaml` - Contains the pod deployment for the StatsD exporter.
- `service.yaml` - Contains the service definition for the StatsD exporter, this exposes both the statsd endpoint (TCP/UDP 8125) and the Prometheus metrics endpoint (HTTP 9102).
- `configmap.yaml` - Contains the mapping for StatsD metrics to Prometheus metrics. This is where you can define how your StatsD metrics should be translated into Prometheus metrics (notably, how metric name components should be translated to labels)
