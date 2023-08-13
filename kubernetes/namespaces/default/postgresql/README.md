# Postgres
This folder contains the manifests for Postgres, our primary database.

You can alter the configuration file inside the `configmap.yaml` file which will be injected into the database container upon boot. Certain parameters (marked in the file) will require a server restart whereas others can be reloaded by using `SELECT pg_reload_conf();` inside Postgres.

Note that there may be up to a minute before your changes to the ConfigMap are reflected inside the container, if things do not change after that you will have to restart the server for the configuration to apply.

## Secrets

postgres requires a `postgres-env` secret with the following entries:

| Environment       | Description                       |
|-------------------|-----------------------------------|
| PGDATA            | The path to the pg_data directory |
| POSTGRES_PASSWORD | The default password to use       |
| POSTGRES_USER     | The default user to use           |
