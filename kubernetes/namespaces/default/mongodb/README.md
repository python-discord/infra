# Python Discord MongoDB
This folder contains the configuration for Python Discord's MongoDB instance.

## Volume
A 10Gi volume is provisioned on the Linode Block Storage (Retain) storage class.

## Secrets
| Key                          | Value                      | Description                     |
| ---------------------------- | -------------------------- | ------------------------------- |
| `MONGO_INITDB_ROOT_USERNAME` | `pythondiscord`            | Username of root user           |
| `MONGO_INITDB_ROOT_PASSWORD` | Root password for database | Password for the root user      |


## Deployment
The deployment will pull the `mongo:latest` image from DockerHub.

It will mount the created volume at `/data/db`.

It will expose port `27017` to connect to MongoDB.

## Service
A service called `mongodb` will be created to give the deployment a cluster local DNS record of `mongodb.default.svc.cluster.local`.
