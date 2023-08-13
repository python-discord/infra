# Graphite

These files provision an instance of the [graphite-statsd](https://hub.docker.com/r/graphiteapp/graphite-statsd/) image.

The following ports are exposed by the service:

**80**: NGINX
**8125**: StatsD Ingest
**8126**: StatsD Admin

There is a 10Gi persistent volume mounted at `/opt/graphite/storage` which holds our statistic data.
