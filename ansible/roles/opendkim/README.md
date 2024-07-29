# OpenDKIM

This role configures the OpenDKIM server used to sign outbound mail from the
Postfix installation.

As a brief summary, this role:
1. Installs OpenDKIM and relevant tools
1. Creates directories for all configured domains
1. Generates the keys with the configured domain & selector
1. Templates the OpenDKIM configuration file
1. Generates the OpenDKIM KeyTable and SigningTable based off configured domains
   and selectors

OpenDKIM is available via port 8891 and binds locally.

When run, the DNS entries required will be made available at the following path:

```
/etc/dkimkeys/{domain}/{selector}.txt
```

The files are in BIND format which is importable to most DNS-hosts but is also
human readable for manual configuration.

The keys are only regenerated when they are not present, to force regeneration
delete the above path but change the extension from `txt` to `private` (the key
file).

## Variables

`opendkim_domains` is a list containing all the domains that mail can be signed
for.

`opendkim_selector` is the selector used for these, normally a hostname or
`default` suffices.
