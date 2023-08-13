# Blackbox
These manifests provision a CronJob for blackbox, our database backup tool.

You can find the repository for blackbox at [lemonsaurus/blackbox](https://github.com/lemonsaurus/blackbox).

## Secrets
blackbox requires the following secrets in a secret titled `blackbox-env`:

| Variable                       | Description            |
|--------------------------------|------------------------|
| **POSTGRES_USER**              | Postgres username      |
| **POSTGRES_PASSWORD**          | Postgres password      |
| **REDIS_PASSWORD**             | Redis password         |
| **MONGO_INITDB_ROOT_USERNAME** | MongoDB username       |
| **MONGO_INITDB_ROOT_PASSWORD** | MongoDB password       |
| **AWS_ACCESS_KEY_ID**          | Access key for S3      |
| **AWS_SECRET_ACCESS_KEY**      | Secret key for S3      |
| **DEVOPS_WEBHOOK**             | Webhook for #dev-ops   |
