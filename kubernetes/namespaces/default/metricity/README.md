# Metricity

This folder contains the secrets for the metricity service.

The actual metricity deployment manifest can be found inside the metricity repository at [python-discord/metricity](https://github.com/python-discord/metricity).

## Secrets
A single secret of name `metricity-env` is used with the following values:

| Environment  | Description                        |
|--------------|------------------------------------|
| BOT_TOKEN    | The Discord bot token to run under |
| DATABASE_URI | Database URI to save the states to |
