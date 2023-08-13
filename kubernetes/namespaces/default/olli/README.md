# Olli

This folder contains the deployment information for [Olli](https://github.com/python-discord/olli), our Loki-Discord relay.

The deployment manifest is located within the repository.

The rest of the configuration can be applied through `kubectl apply -f .` in this directory.

A secret called `olli-env` with the following a key `WEBHOOK_URL` with the configured Discord webhook.

| Key           | Description                |
| --------------| -------------------------- |
| `WEBHOOK_URL` | The Discord webhook to use |
