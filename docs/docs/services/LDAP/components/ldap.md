---
description: Maintenance guidance of the Python Discord LDAP service
---
# LDAP

You can interact directly with LDAP using command line tools such as
`ldapsearch` and `ldapmodify`. If you prefer a graphical interface, you can use
tools like Apache Directory Studio.

Our LDAP Base DN is `dc=box,dc=pydis,dc=wtf`, so users reside under a DN like
`uid=yourusername,cn=users,cn=accounts,dc=box,dc=pydis,dc=wtf`.

You can authenticate with these tools using your own LDAP credentials which have
administrator privileges.

In order for connections to be trusted, you may need a copy of the CA
certificate.

You can fetch a copy using the following command on either the `ldap01` host or
`lovelace`.

```bash
$ rsync ldap01.box.pydis.wtf:/etc/ipa/ca.crt .
```

Once you have this certificate, you can prepend the `ldapsearch` command with
the following:

```bash
$ LDAPTLS_CACERT=ca.crt ldapsearch -x -H ldaps://ldap01.box.pydis.wtf -D "uid=yourusername,cn=users,cn=accounts,dc=box,dc=pydis,dc=wtf" -W
```
