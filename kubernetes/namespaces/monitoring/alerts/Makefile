.PHONY: alerts alertmanager

all: alerts alertmanager

# Upload the alerting rules to the Kubernetes cluster
alerts:
	kubectl create configmap -n monitoring prometheus-alert-rules --from-file=alerts.d/ -o yaml --dry-run=client | kubectl apply -f -

# Upload the alertmanager configuration to the Kubernetes cluster
alertmanager:
	kubectl create configmap -n monitoring alertmanager-config --from-file=alertmanager.yaml=alertmanager.yaml -o yaml --dry-run=client | kubectl apply -f -
