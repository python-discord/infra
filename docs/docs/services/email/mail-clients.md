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
submission on port 465 (preferred) or 587, leave TLS/SSL settings as your mail client
defaults.

Your mail client should also support IMAP via the same host.

You can use your username or full email as the IMAP & SMTP username.

You can configure your mail client to send from any of your aliases, e.g.
`joe@pydis.wtf` or `joe@pydis.com`.

!!! tip "SMTP on port 465"

    Using SMTP on port `465` (SMTP-over-TLS) is preferred to `587` (STARTTLS) as
    with port 465 you are guaranteed a secure TLS session from connection
    establishment.

    With port `587` the connection begins unencrypted and is later upgraded via
    the SMTP `STARTTLS` command, however, if either the client or server is
    misconfigured this can lead to potential exposure of client credentials.

    Hence, we recommend using port 465 from mail clients if they are supported
    in order to guarantee end-to-end security between your client and the mailserver.

To summarise:

| Configuration Option | Value                      |
|----------------------|----------------------------|
| Mail server address  | `mail.pydis.wtf`           |
| Inbox protocol       | `IMAP`                     |
| SMTP Port            | `465` (preferred) or `587` |
| SMTP TLS             | Mail client default        |
| SMTP Username        | `username@pydis.wtf`       |
| SMTP Password        | Your LDAP password         |

If you need any extra help or believe your client requires other settings that
are not provided by the PyDis mailserver please let us know in `#dev-oops`.

## Sieve

We support server-side email filtering with [Pigeonhole
Sieve](https://doc.dovecot.org/configuration_manual/sieve/pigeonhole_sieve_interpreter/).
Sieve scripts are managed via [the ManageSieve
protocol](https://datatracker.ietf.org/doc/html/rfc5804). Your e-mail client
should have built-in functionality for writing and editing these scripts. See
[the official Sieve website](http://sieve.info/) for more information.

If you're looking for clients, [`sieve-connect` is a solid
CLI](https://people.spodhuis.org/phil.pennock/software/), and [Thomas Schmid's
`sieve`](https://github.com/thsmi/sieve) is a solid GUI.

Using this, users can perform common mail tasks automatically by writing small
sieve scripts that are able to act on inbound mail before it reaches a user
inbox.

!!! note

    Sieve only applies to mail destined for IMAP folders, if mail is being forwarded
    then sieve scripts will not be executed. It is up to you to implement Sieve scripts
    or use other inbox rule engines at your destination mailserver if you have configured
    email forwarding.

You can start with Sieve by writing scripts to the `~/sieve` file of your home
directory. This will be read and executed on all inbound mail.

You can find some example scripts to get started
[here](https://doc.dovecot.org/configuration_manual/sieve/examples/).

There are plenty of resources out there to allow for filtering using Sieve
rules.

### Debugging Sieve scripts

Dovecot ships with a helpful utility called `sieve-test` which allows you to
test the execution of a Sieve script when given an e-mail. You pass it a sieve
script and an e-mail, and (depending on the flags you pass it) it shows you
information on what Dovecot would do with said e-mail.

Let's take the following Sieve script intended to file away mailing list posts
to the right folders:

```sieve
require ["fileinto", "subaddress", "variables", "regex", "mailbox"];

if header :matches "List-Unsubscribe" "*" {
    if header :regex "List-Id" "^<(\w+)\.(example)\.org>$" {
        set "list_name" "${1}";
        set "org_name" "${2}";

        fileinto :create "Lists.${org_name}.${list_name}";
    } else {
        fileinto :create "Lists";
    }
    stop;
}
```

This example has a slight problem. Whilst the e-mail header `List-Id` is being
sent in the form `<group.example.org>`, it does not seem to file it into the
proper place.

To test it, start by copying a mail you want to test it with (or creating one)
in your home directory. Then run the following:

```
sudo -u vmail sieve-test -Tlevel=matching -t - $SIEVE $MAIL
```

where `$SIEVE` is the Sieve script you'd like to debug and `$MAIL` is the path
to the e-mail you'd like to test it on. It prints execution information as
follows:

```sh
            ## Started executing script 'sieve'
   3: header test
   3:   starting `:matches' match with `i;ascii-casemap' comparator:
   3:   extracting `List-Unsubscribe' headers from message
   3:   matching value `<mailto:list@example.org?body=unsub%20list>'
   3:     with key `*' => 1
   3:   finishing match with result: matched
   3: jump if result is false
   3:   not jumping
   4: header test
   4:   starting `:regex' match with `i;ascii-casemap' comparator:
   4:   extracting `List-Id' headers from message
   4:   matching value `<list.example.org>'
   4:     with regex `^<(w+).(.*)>$' [id=0] => 0
   4:   finishing match with result: not matched
   4: jump if result is false
   4:   jumping to line 9
  10: fileinto action
  10:   store message in mailbox `Lists'
  12: stop command; end all script execution
      ## Finished executing script 'sieve'
```

Note number `4:` where it says that `finishing match with result: not matched`.
If you look carefully at the Regex pattern, you'll notice that it does not work
look right because the pattern on the left is `(w+)` which would match on
consecutive `w`s as opposed to `\w`.

In this example, the fix is to simply add another backslash ahead of `\w` to
ensure that the pattern is correctly parsed by Dovecot. To conclude,
`sieve-test` allows you to easily find bugs like this without having to
repeatedly retry script execution with inbound e-mails.


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

mailboxes $spoolfile +Archive $postponed $record +Junk $trash
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
