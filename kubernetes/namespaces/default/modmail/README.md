# Modmail

This folder contains the manifests for our Modmail service.

## Secrets

The services require one shared secret called `modmail` containing the following:

| Key                     | Value                            | Description                                                  |
| ------------------------| ---------------------------------|--------------------------------------------------------------|
| `CONNECTION_URI`        | MongoDB connection URI           | Used for storing data                                        |
| `DATABASE_TYPE`         | `mongodb`                        | The type of database to use, only supports mongodb right now |
| `DATA_COLLECTION`       | `False`                          | Disable bot metadata collection by modmail devs              |
| `DISABLE_AUTOUPDATES`   | `yes`                            | Auto-updates breaks in production                            |
| `GUILD_ID`              | Snowflake of Discord guild       | Guild to respond to commands in                              |
| `LOG_URL`               | URL of the web portal            | Used for generating links on the bot                         |
| `OWNERS`                | Comma separated list of user IDs | Used for granting high permissions on the bot                |
| `REGISTRY_PLUGINS_ONLY` | `false`                          | Allows the usage of plugins outside of the official registry |
| `TOKEN`                 | Discord Token                    | Used to connect to Discord                                   |
