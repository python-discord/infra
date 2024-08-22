---
description: Configuration for setting up local email clients with the pydis.wtf mailserver
---
# Mail Clients (IMAP & SMTP)

If you have not configured a forwarding address in Keycloak (see [the Keycloak
manual](../LDAP/components/keycloak.md)), then you are able to access email over
IMAP.

!!! note "IMAP when forwarding address is configured"

    If you have configured a forwarding address you will still be able to login to
    IMAP and send mail, but any received mail will go to your forwarding address and will
    not be delivered locally.

    If you wish to deliver both locally and forward to another address, find an email
    client with these features and configure your forwarding there.

## Client Configuration

You can configure your mail client to point to `mail.pydis.wtf`, we support SMTP
submission on port 465 or 587, leave TLS/SSL settings as your mail client
defaults.

Your mail client should also support IMAP via the same host.

You can use your username or full email as the IMAP & SMTP username.

You can configure your mail client to send from any of your aliases, e.g.
`joe@pydis.wtf` or `joe@pydis.com`.

To summarise:

| Configuration Option | Value                |
|----------------------|----------------------|
| Mail server address  | `mail.pydis.wtf`     |
| Inbox protocol       | `IMAP`               |
| SMTP Port            | `465` or `587`       |
| SMTP TLS             | Mail client default  |
| SMTP Username        | `username@pydis.wtf` |
| SMTP Password        | Your LDAP password   |

If you need any extra help or believe your client requires other settings that
are not provided by the PyDis mailserver please let us know in `#dev-oops`.

## Neomutt via SSH

Previously, before we had configured IMAP, local mail delivery was read with
`neomutt`.

We have reconfigured `neomutt` to attempt to connect via IMAP, however we
obviously cannot complete the transaction entirely without user passwords.

For this reason, when attempting to read mail with `neomutt` via SSH you will be
asked for your IMAP password.

You can enter your password here and you will be able to browse your inbox,
archives, drafts and sent mail (all are automatically configured to the IMAP
equivalent).

Whilst strongly advised against, you can set the `imap_pass` attribute in your
`neomuttrc` to automatically connect to IMAP.

You can read more about neomutt's IMAP support
[here](https://neomutt.org/test-doc/bestpractice/nativimap).

You can view the default configuration that PyDis injects to neomutt in the
`/etc/neomuttrc.d/pydis.rc` file, at time of writing:

```bash
# neomutt will use ~/Mail by default, which with our mailserver
# being backed by Dovecot we do not support. Hence, we configure
# IMAP here to allow mail to be read by users logged in via SSH.

set spoolfile="imaps://mail.pydis.wtf/"
set imap_user="$USER"

set folder = $spoolfile
set postponed  = "+Drafts"
set record     = "+Sent"
set trash      = "+Trash"

mailboxes $postponed $record $trash
```

## Bonus: Contact Lists

!!! example "Untested Functionality"

    Whilst this feature is shipped natively with Thunderbird, we have not tested
    this extensively. Results returned by the LDAP server may be confusing, inaccurate
    or otherwise not useful.

Whilst mostly unsupported, you can use the LDAP server as a contact directory in
some email clients.

In Thunderbird, under account settings and composition & addressing, you can add
a new LDAP directory with the following parameters.

| Option                | Value                                                        |
|-----------------------|--------------------------------------------------------------|
| Name                  | `PyDis`                                                      |
| Hostname              | `ldap01.box.pydis.wtf`                                       |
| Base DN               | `cn=users,cn=accounts,dc=box,dc=pydis,dc=wtf`                |
| Port Number           | `636`                                                        |
| Bind DN               | `uid=<username>,cn=users,cn=accounts,dc=box,dc=pydis,dc=wtf` |
| Use secure connection | `Yes`                                                        |

You should then be able to use this directory in the address book (`Alt+2`). The
first time you use it you may need to input your password and accept a
certificate security warning.
