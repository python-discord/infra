certs:
	cat *.pem > ca.crt

secret:
	kubectl create secret -n kube-system generic mtls-client-crt-bundle --from-file=ca.crt=ca.crt

all: certs secret

delete:
	kubectl delete secret -n kube-system mtls-client-crt-bundle
