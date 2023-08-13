## Sir-Robin
Deployment file for @Sir-Robin, the not-quite-so-bot as Sir Lancebot, is our humble events bot.
He is tasked with dealing with all the things that the event team can throw at it!

## Secrets
This deployment expects a number of secrets/environment variables to exist in a secret called `sir-robin-env`. The bot also relies on redis credentials being available in a secret named `redis-credentials`

| Environment               | Description                                   |
|---------------------------|-----------------------------------------------|
| AOC_LEADERBOARDS          | A list of all AOC leaderboards to use         |
| AOC_STAFF_LEADERBOARD_ID  | The staff AOC leaderboard.                    |
| AOC_YEAR                  | The current year to use for AOC               |
| BOT_DEBUG                 | Whether debug is enabled (true/false)         |
| BOT_TOKEN                 | The bot token to run the bot on.              |
| CODE_JAM_API_KEY          | The API key to the code jam management system |
| SITE_API_TOKEN            | The token to access the site API.             |
| SITE_URL                  | The base URL for our website.                 |
