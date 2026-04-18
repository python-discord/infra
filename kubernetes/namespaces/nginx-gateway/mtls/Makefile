.PHONY: certs configmap all delete

all: certs configmap

certs:
	cat *.pem > ca.crt

configmap:
	kubectl create configmap -n nginx-gateway mtls-client-crt-bundle --from-file=ca.crt=ca.crt

delete:
	kubectl delete configmap -n nginx-gateway mtls-client-crt-bundle
