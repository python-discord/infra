# pinnwand
These manifests provision an instance of the pinnwand service used on https://paste.pythondiscord.com.

A init-service is used to download the Python Discord banner logo and save it to a volume, as pinnwand expects it to be present within the image.

## Secrets & config
This deployment expects an env var named `PINNWAND_DATABASE_URI` to exist in a secret called `pinnwand-postgres-connection`.
All other configuration can be found in `defaults-configmap.yaml`.
