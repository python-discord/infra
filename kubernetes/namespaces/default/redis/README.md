# Python Discord Redis
This folder contains the configuration for Python Discord's Redis instance.

## ConfigMap
**We'll need to create a ConfigMap for this service, which will hold the `redis.conf` configuration.**

Do the following:
1. Make a copy of `redis.conf.template` called `redis.conf`
2. Edit your `redis.conf` to replace `<INSERT PASSWORD>` with the password you'd like your redis instance to use.
3. Use `kubectl create configmap redis-conf --from-file=redis.conf` to create the ConfigMap
4. Delete the `redis.conf`. **We don't wanna commit that password anywhere!**

## Volume
A 10Gi volume is provisioned on the Linode Block Storage (Retain) storage class.

## Deployment
The deployment will pull the `redis:latest` image from DockerHub.

It will mount the created volume at `/data`.

It will expose port `6379` to connect to Redis.

## Service
A service called `redis` will be created to give the deployment a cluster local DNS record of `redis.default.svc.cluster.local`.

## Secrets

Redis requires a `redis-credentials` secret with the following entries:

| Environment    | Description                           |
|----------------|---------------------------------------|
| REDIS_HOST     | The host redis is running on          |
| REDIS_PASSWORD | The password to connect to redis with |
| REDIS_PORT     | The port redis is listening on        |
