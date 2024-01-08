## Bot

Deployment file for @Python, our valiant community bot and workhorse.

## Secrets
This deployment expects a number of secrets and environment variables to exist in a secret called `bot-env`.

| Environment       | Description                                                 |
|-------------------|-------------------------------------------------------------|
| API_KEYS_GITHUB   | An API key for Github's API.                                |
| API_KEYS_SITE_API | The token to access our site's API.                         |
| BOT_SENTRY_DSN    | The sentry DSN to send sentry events to.                    |
| BOT_TOKEN         | The Discord bot token to run the bot on.                    |
| METABASE_PASSWORD | Password for Metabase                                       |
| METABASE_USERNAME | Username for Metabase                                       |
