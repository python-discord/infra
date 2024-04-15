# Python Discord Site
This folder contains the manifests for Python Discord site.

## Serving static files

Usually, a web server like `nginx` should be deployed and configured to serve static files needed by Django. Then we'd put an `Ingress`
rule to route traffic to the `STATIC_URL` to that webserver.
Check the [official docs](https://docs.djangoproject.com/en/4.2/howto/static-files/deployment/) for more info.

In this setup, we do it differently thanks to [WhiteNoise](https://whitenoise.readthedocs.io/en/stable/base.html#), which sets up
a middleware that handles the caching, compression and serving of the static files for us.

## Secrets

The deployment expects the following secrets to be available in `site-env`:

| Environment           | Description                                                |
|-----------------------|------------------------------------------------------------|
| DATABASE_URL          | The URL for the Postgresql database.                       |
| GITHUB_APP_ID         | The ID of a GitHub Application (related to the above key). |
| GITHUB_APP_KEY        | A PEM key for a GitHub Application.                        |
| GITHUB_TOKEN          | An API key to the Github API                               |
| METRICITY_DB_URL      | The URL for the Metricity database.                        |
| SECRET_KEY            | Secret key for Django.                                     |
| SITE_DSN              | The Sentry Data Source Name.                               |
