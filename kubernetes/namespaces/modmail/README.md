# Modmail

This folder contains the manifests for our Modmail service.

## Secrets

The services require one shared secret called `modmail` containing the following:

| Key                     | Value                            | Description                                                  |
| ------------------------| ---------------------------------|--------------------------------------------------------------|
| `CONNECTION_URI`        | MongoDB connection URI           | Used for storing data                                        |
| `TOKEN`                 | Discord Token                    | Used to connect to Discord                                   |
