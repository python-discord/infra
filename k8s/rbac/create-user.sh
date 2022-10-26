#!/bin/bash
#
# Usage:
#
#   ./create-user.sh pydis:joe.banks pydis:devops-admins
#
# Please use the full names of users to follow the standard.

set -eu

# Assumes user already exists
# Performs the X.509 bullshittery
# Getting "bla bla bla bullshit does not mathc public key bla bla bla bullshit?"
# Delete the CSR using `kubectl delete csr pydis:user.name`

USERNAME="$1"
GROUP="$2"

FILENAMEBASE="${USERNAME/pydis:/}"
openssl genrsa -out "$FILENAMEBASE.key" 2048
openssl req -new -key "$FILENAMEBASE.key" -out "$FILENAMEBASE.csr" -subj "/CN=${USERNAME}/O=${GROUP}"
REQUEST="$(base64 -w 0 < "$FILENAMEBASE.csr")"

cat <<EOF | kubectl apply -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: $USERNAME
spec:
  request: $REQUEST
  signerName: kubernetes.io/kube-apiserver-client
  expirationSeconds: 315360000  # ten years
  usages:
  - client auth
EOF

kubectl certificate approve "$USERNAME"
kubectl get csr "$USERNAME" -o jsonpath='{.status.certificate}'| base64 -d > "$FILENAMEBASE.crt"

echo "Send the following files to the minion:"
echo
echo "  $USERNAME.crt"
echo "  $USERNAME.key"
echo "  pydis-netkube.crt"
echo
echo "Send along the following commands and instruct the minion to run it:"
echo
echo "  kubectl config set-credentials $USERNAME --client-key=$FILENAMEBASE.key --client-certificate=$FILENAMEBASE.crt --embed-certs=true"
echo "  kubectl config set-cluster pydis-netkube --server=https://turing.box.pydis.wtf:6443 --certificate-authority=pydis-netkube.crt --embed-certs=true"
echo "  kubectl config set-context pydis-netkube --cluster=pydis-netkube --user=$USERNAME"
echo "  kubectl config use-context pydis-netkube"
echo


read -p "Hit enter when files were sent to shred them: "
shred -u "$FILENAMEBASE.key" "$FILENAMEBASE.crt" "$FILENAMEBASE.csr"
