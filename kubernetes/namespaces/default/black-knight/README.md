## Black Knight
Deployment file for @Black-Knight, our courageous and ever present anti-raid bot.

## Secrets
This deployment expects a number of secrets/environment variables to exist in a secret called `black-knight-env`.

| Environment           | Description                                                       |
|-----------------------|-------------------------------------------------------------------|
| BOT_TOKEN             | The Discord bot token for Black Knight to connect to Discord with |
| DATABASE_URL          | A full PostgreSQL connection string to the postgres db            |
| BOT_SENTRY_DSN        | The DSN to connect send sentry reports to                         |

Black knight also requires a redis password, which is pulled from the `redis-credentials` secret.
```
REDIS_PASSWORD - The password to redis
```
