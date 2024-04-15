# Prestashop

This folder contains the ingress and values.yaml file for the deployment of Prestashop, used for our merch store. It additionally deploys MariaDB, used for data storage.

## Deployment

```
$ helm repo add bitnami https://charts.bitnami.com/bitnami
$ helm install prestashop bitnami/prestashop -f prestashop/values.yaml --set prestashopPassword=<admin passsword>,mariadb.auth.rootPassword=<database password>,smtpPassword=<password from mailgun>
```

The Helm chart can be located [here](https://github.com/bitnami/charts/tree/master/bitnami/prestashop), including all available parameters.
