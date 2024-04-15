# Python Discord Redis
This folder contains the configuration for Python Discord's Redis instance.

## Volume
A 10Gi volume is provisioned on the Linode Block Storage (Retain) storage class.

## Deployment
The deployment will pull the `redis:latest` image from DockerHub.

It will mount the created volume at `/data`.

It will expose port `6379` to connect to Redis.

## Service
A service called `redis` will be created to give the deployment a cluster local DNS record of `redis.databases.svc.cluster.local`.

## Secrets

Redis requires a `redis-credentials` secret with the following entries:

| Environment    | Description                           |
|----------------|---------------------------------------|
| REDIS_HOST     | The host redis is running on          |
| REDIS_PASSWORD | The password to connect to redis with |
| REDIS_PORT     | The port redis is listening on        |
