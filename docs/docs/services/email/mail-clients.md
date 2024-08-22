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


### Contact List

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
