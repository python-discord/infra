---
description: Configuration for getting mail delivered to Postfix into a local folder
---
# Local Delivery

We use the Dovecot LMTP daemon to deliver mail destined to local mailboxes (i.e.
that has not been forwarded or processed by a service) into the relevant folders
for IMAP consumption.

As shown in the [Postfix Overview](../../components/postfix.md), mail destined to
local addresses is sent to the Dovecot LMTP agent to be placed into the relevant
`/var/vmail` folder.

Postfix still performs all pre-delivery checks and handles rejections for
messages that have not met the delivery criteria (i.e. spoofed SPF or DKIM).

*[LMTP]: Local Mail Transfer Protocol
