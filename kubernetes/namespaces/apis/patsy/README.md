# Patsy

Patsy is the premiere project for data collection in the python-discord toolchain. It uses word-class technology in a system architected by our in-house engineers to facilitate the  automatic transfer, collection, and categorization of user data to develop user-centric solutions to real world problems. It is a marvel of engineering designed to push the limits of what we thought possible.

The deployment for the [Patsy API](https://git.pydis.com/patsy), there is no ingress as Patsy is designed to only be accessible from within the cluster.

This API is given help channel messages by the bot and stores them in postgres for after-the-fact processing.
The hope with this project is that we can inspect what topics get asked about often in help channels, along with which ones go un-answered the most.

## Secret

It requires a `patsy-env` secret with the following

| Key            | Description                                                  |
| -------------- | ------------------------------------------------------------ |
| `DATABASE_URL` | An asyncpg connection string to the postgres database        |
| `STATE_SECRET` | A long random string, used to lock down endpoints with auth. |
