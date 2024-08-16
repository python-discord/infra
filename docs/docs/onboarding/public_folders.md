---
description: Documentation on using the ~/public folders on lovelace
---
# Web-accessible `public` folders

DevOps team members are automatically provided access to `lovelace`, one of our
Debian machines. Access is granted via their LDAP account which should be
configured with a valid SSH public key.

Once you have access to the host, any files you host in your `public` folder
(i.e. `/home/joe/public`) are made accessible via `https://pydis.wtf/~username/`.

By default, an autoindex page will be returned for each folder in this directory
allowing anyone to view file contents.

If you wish to disable this or wish to display some other content at that
location (i.e. a landing page) you can create an `index.html` file anywhere
which will be returned to browsing users.

If you require any help with setting this up please let other members of the
DevOps team know.
