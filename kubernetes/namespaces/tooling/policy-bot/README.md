# Policy Bot
Policy Bot is our instance of [palantir/policy-bot](https://github.com/palantir/policy-bot) for managing review policy across our GitHub repositories.

Actual review policy is stored inside our GitHub repositories in the `.github/review-policy.yml` file, so the configuration here is purely for interacting with GitHub and some lower level things.

## GitHub Configuration

Follow the instructions in the [repository](https://github.com/palantir/policy-bot#deployment) to provision a GitHub application. Our manifests are configured to run the policy bot at https://policy-bot.pydis.wtf/.

## Secrets

This app requires a `policy-bot-defaults` secret with the following entries:

| Environment                                      | Description                                                           |
|--------------------------------------------------|-----------------------------------------------------------------------|
| GITHUB_APP_PRIVATE_KEY                           | Contents of the PEM certificate downloadable from the GitHub App page |
| GITHUB_APP_WEBHOOK_SECRET                        | Webhook secret from GitHub App Page                                   |
| GITHUB_OAUTH_CLIENT_SECRET                       | OAuth 2 client secret from Github App page                            |
| POLICYBOT_OPTIONS_DO_NOT_LOAD_COMMIT_PUSHED_DATE | Set to True to not use deprecated commit_pushed_date from Github API  |
| POLICYBOT_SESSIONS_KEY                           | Random characters for signing user sessions                           |

Run `kubectl apply -f .` inside this directory to apply the the configuration.

Access the running application over [policy-bot.pydis.wtf]([https://policy-bot.pydis.wtf/])!
