# Modmail

This namespace runs our Modmail system.

| Component | Description |
| --------- | ----------- |
| Polonium (`polonium-api`, `polonium-bot`) | The current Modmail bot. Its manifests are not in this directory. |
| [`barium/`](./barium) | Read-only viewer for logs from the **legacy** Modmail bot, so old `modmail.pydis.wtf/logs/<key>` links keep working. |

The legacy Modmail bot and its web logviewer have been retired. Their logs were exported from MongoDB
and are now served statically by Barium.

## Secrets

The `modmail` secret is shared by the Polonium deployments.
