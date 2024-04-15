# Forms Backend

Forms backend is our surveyance system for putting out forms in our community.

This directory contains the necessary routing manifests, the deployment is located in the [python-discord/forms-backend](https://github.com/python-discord/forms-backend) repository.

This deployment expects a number of secrets and environment variables to exist in a secret called `forms-backend-env`.

| Environment          | Description                                                     |
|----------------------|-----------------------------------------------------------------|
| DATABASE_URL         | A MongoDB database url                                          |
| DISCORD_BOT_TOKEN    | The bot token to connect to Discord's API with                  |
| DOCS_PASSWORD        | The password required to access the auto-generated API docs     |
| HCAPTCHA_API_SECRET  | The API key to HCAPTCHA's API                                   |
| OAUTH2_CLIENT_ID     | The Discord app OAuth2 client id                                |
| OAUTH2_CLIENT_SECRET | The Discord app OAuth2 client secret                            |
| PRODUCTION           | Whether the app is in production true/false                     |
| SECRET_KEY           | The key to sign all JWTs with                                   |
| SNEKBOX_URL          | The URL to the senkbox service to use for code form submissions |
| FORMS_BACKEND_DSN    | The sentry DSN to send sentry events to                         |
