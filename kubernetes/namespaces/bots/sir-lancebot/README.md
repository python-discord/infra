## Sir Lancebot
```
Oh brave Sir Lancebot!

Whereat he turned and stood with folded arms and numerous antennae,
"Why frown upon a friend? Few live that have too many."
A weary-waiting optical array, now calibrated to a sad wrath.
Hereafter, thus t'was with him that we hath forged our path.
```

## Secrets
This deployment expects a number of secrets and environment variables to exist in a secret called `sir-lancebot-env` shown below. The bot also relies on redis credentials being available in a secret named `redis-credentials`


| Environment               | Description                              |
|---------------------------|------------------------------------------|
| BOT_SENTRY_DSN            | The DSN for the Sentry project.          |
| CLIENT_DEBUG              | Should the bot start in DEBUG mode?      |
| CLIENT_TOKEN              | The bot token to run the bot on.         |
| LATEX_API_URL             | The URl tha the latex API is served from |
| TOKENS_GIPHY              | API key for Giphy.                       |
| TOKENS_GITHUB             | GitHub access token, for Hacktoberstats. |
| TOKENS_IGDB_CLIENT_ID     | Client ID IGDB - used to find games.     |
| TOKENS_IGDB_CLIENT_SECRET | Client secret IGDB - used to find games. |
| TOKENS_NASA               | API key for NASA.                        |
| TOKENS_TMDB               | Token for TMBD. Used for scarymovie.py.  |
| TOKENS_UNSPLASH           | Token for unsplash.                      |
| TOKENS_YOUTUBE            | API key for YouTube.                     |
| WOLFRAM_KEY               | API key for Wolfram Alpha.               |
