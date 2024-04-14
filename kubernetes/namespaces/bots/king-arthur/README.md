# King Arthur

Deployment file for @King Arthur, our DevOps helper bot.

## Secrets
This deployment expects a number of secrets and environment variables to exist in a secret called `king-arthur-env`.

| Environment                  | Description                                                               |
| ---------------------------- | ------------------------------------------------------------------------- |
| KING_ARTHUR_TOKEN            | The token to authorize with Discord                                       |
| KING_ARTHUR_NOTION_API_TOKEN | The API token to the notion API                                           |
| KING_ARTHUR_CLOUDFLARE_TOKEN | A token for the Cloudflare API used for the Cloudflare commands in Arthur |
