# Code Jam Management

This contains the deployment for the internal [code jam management](https://github.com/python-discord/code-jam-management) service.

### Required Secret
In a secret named `code-jam-management-env`:

| Environment  | Description                                                            |
|--------------|------------------------------------------------------------------------|
| API_TOKEN    | A random string to use as the auth token for making requests to CJMS   |
| DATABASE_URL | `postgres://<user>:<password>@<host>:<port>/<name>`                    |
