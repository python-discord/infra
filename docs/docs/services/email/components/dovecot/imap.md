---
description: Our IMAP configuration for Python Discord
---
# IMAP

!!! note

    This is a technical overview of our IMAP configuration, for guidance on
    setting up and using IMAP, check the [Mail Clients](../../mail-clients.md)
    documentation.

We use a mostly standard Dovecot configuration, with the primary difference
being that we make use of the LDAP integrations to provide our `userdb`.

Our IMAP configuration automatically creates the following folders:

| Folder Name        | Purpose                    |
|--------------------|----------------------------|
| Inbox              | Newly received mail        |
| Drafts             | Draft (postponed) messages |
| Junk               | Mail marked as spam[^1]    |
| Trash              | Mail deleted by users[^2]  |
| Sent/Sent Messages | Messages sent by the user  |

Mail is delivered into the `/var/vmail/%USER` directory, owned by the `vmail`
non-privileged user.

Dovecot then exposes this folder over IMAP and allows user mailbox modification
using IMAP-compatible mail clients.

[^1]: We have not yet implemented a spam filtering solution and so for now this
    box contains only mail the user has explicitly marked as junk.

[^2]: Mail in this folder is automatically wiped after 60 days.
