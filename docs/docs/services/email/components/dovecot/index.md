---
description: Overview of Dovecot, our local mail delivery and IMAP daemon.
---
# Dovecot

We use [Dovecot](https://www.dovecot.org/) for both local delivery and IMAP access to mailboxes.

<div class="grid cards" markdown>

-   :material-inbox-arrow-down:{ .lg .middle } __Local Delivery__

    ---

    Configuration for delivering inbound mail from Postfix to a directory.

    [:octicons-arrow-right-24: Read more](./local-delivery.md)

-   :simple-thunderbird:{ .lg .middle } __IMAP__

    ---

    Configuration for users accessing mailboxes over IMAP protocol.

    [:octicons-arrow-right-24: Read more](./imap.md)

</div>

## LDAP Users

Dovecot checks against our LDAP directory for users before attempting mail
delivery or permitting access to a mailbox.

Dovecot performs Bind authentications meaning it tests the credentials provided
by the user against the LDAP directory, and does not perform the password
validation itself.

We permit the following login mechanisms:

- `PLAIN` (Plaintext passwords, with security added by TLS/SSL)
- `LOGIN` (Obsolete, but still used by Microsoft services)

When a user authenticates, we confirm the login with the LDAP directory and
permit access, either to the SMTP server via Dovecot SASL or to IMAP via Dovecot
authentication.

## Administration

Dovecot mostly services itself, you can check the logs by looking for
`dovecot.service` in the system journal.

You can perform a selection of administration tasks with the `doveadm` tool,
which has a great manpage.

This includes things like testing LDAP lookups (`doveadm user`), listing folders
in a user mailbox (`doveadm mailbox`), or viewing Dovecot service status
(`dovecot process status`).
