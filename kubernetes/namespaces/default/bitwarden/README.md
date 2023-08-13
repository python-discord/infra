# BitWarden

Our internal password manager, used by the admins to share passwords for our services. Hosted at https://bitwarden.pythondiscord.com

To deploy this, first set up the secrets (see below) and then run `kubectl apply -f .` in this folder.

## Secrets
This deployment expects a few secrets to exist in a secret called `bitwarden-secret-env`.


| Environment           | Description                               |
|-----------------------|-------------------------------------------|
| ADMIN_TOKEN           | 64-character token used for initial login |
| DATABASE_URL          | Database string: host://user:pass/db      |
