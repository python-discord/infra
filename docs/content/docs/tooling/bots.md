---
title: GitHub Bots
description: |
  Information on robots that keep our GitHub repositories running at full steam.
---

Our GitHub repositories are supported by two custom bots:

- Our **Fast Forward Bot**, which ensures that commits merged into main are
  either merged manually on the command line or via a fast-forward, ensuring
  that cryptographic signatures of commits remain intact. Information on the
  bot can be found [in the `ff-bot.yml`
  configuration](https://github.com/python-discord/infra/blob/main/.github/ff-bot.yml).
  Merges over the GitHub UI are discouraged for this reason. You can use it by
  running `/merge` on a pull request. Note that attempting to use it without
  permission to will be reported.

- Our **Craig Dazey Emulator Bot**, which ensures team morale stays high at all
  times by thanking team members for submitted pull
  requests.[^craig-dazey-legal-team-threats]

Furthermore, our repositories all have dependabot configured on them.


## Dealing with notifications

This section collects some of our team members' ways of dealing with the
notifications that originate from our bots.

### Sieve (RFC 5228) script

If your mail server supports the [Sieve mail filtering
language](https://datatracker.ietf.org/doc/html/rfc5228.html), which it should,
you can adapt the following script to customize the amount of notifications you
receive:

```sieve
require ["envelope", "fileinto", "imap4flags"];

if allof (header :is "X-GitHub-Sender" ["coveralls", "github-actions[bot]", "netlify[bot]"],
          address :is "from" "notifications@github.com") {
    setflag "\\seen";
    fileinto "Trash";
    stop;
}
```



[^craig-dazey-legal-team-threats]: Craig Dazey Emulator Bot stands in no
    affiliation, direct or indirect, with Craig Dazey. Craig Dazey Emulator
    Bot.  Craig Dazey Emulator Bot is not endorsed by Craig Dazey. Craig Dazey
    Emulator Bot is an independent project of Craig Dazey. No association is
    made between Craig Dazey Emulator Bot and Craig Dazey.
