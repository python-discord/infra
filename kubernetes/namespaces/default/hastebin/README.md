# Hastebin
These manifests provision an instance of the hastebin service used on https://paste-old.pythondiscord.com

## How to deploy this service
- Check the defaults in `defaults-configmap.yaml` match what you want.

This deployment expects an environment variable to exist in a secret called `hastebin-redis-password`.

| Environment      | Description                                           |
|------------------|-------------------------------------------------------|
| STORAGE_PASSWORD | The password to the redis instance to store pastes to |
