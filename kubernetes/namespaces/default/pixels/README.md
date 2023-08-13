# Pixels

The deployment for the [Pixels project](https://git.pydis.com/pixels-v2), hosted at https://pixels.pythondiscord.com.

## Secret

It requires a `pixels-env` secret with the following entries:

| Environment   | Description                                                                                             |
|---------------|---------------------------------------------------------------------------------------------------------|
| AUTH_URL      | A Discord OAuth2 URL with scopes: identify & guilds.members.read                                        |
| BASE_URL      | Where the root endpoint can be found                                                                    |
| CLIENT_ID     | Discord Oauth2 client ID                                                                                |
| CLIENT_SECRET | Discord Oauth2 client secret                                                                            |
| DATABASE_URL  | Postgres database URL.                                                                                  |
| FORCE_LOGIN   | Whether to requires authorization for all endpoints beside the login page, and limits access to helpers |
| GUILD_ID      | The guild to check for user roles in                                                                    |
| HELPERS_ROLE  | Helpers role ID                                                                                         |
| JWT_SECRET    | 32 byte (64 digit hex string) secret for encoding tokens. Any value can be used.                        |
| LOG_LEVEL     | What level to log at                                                                                    |
| MOD_ROLE      | Moderator role ID                                                                                       |
| PRODUCTION    | Whether the app is in production                                                                        |
| REDIS_URL     | Redis storage URL                                                                                       |
| SENTRY_DSN    | The Sentry DSN to send sentry events to                                                                 |
| WEBHOOK_URL   | The webhook to periodically post the canvas state to                                                    |
