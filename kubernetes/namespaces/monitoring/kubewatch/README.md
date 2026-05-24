# Kubewatch

> **kubewatch** is a Kubernetes watcher that currently publishes notification to available collaboration hubs/notification channels. Run it in your k8s cluster, and you will get event notifications through webhooks.

```
$ helm repo add robusta https://robusta-charts.storage.googleapis.com
$ helm repo update
$ helm upgrade --install -n monitoring --values kubewatch_values.yaml kubewatch robusta/kubewatch
```
