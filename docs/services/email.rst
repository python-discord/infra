E-Mail
======

We run an E-mail forwarding service for the ``pythondiscord.com``,
``pydis.com`` and ``pydis.wtf`` domains.

.. contents::
   :depth: 3


User manual
-----------

Any e-mail forwarding requires you to configure the target forwarding address
first, otherwise, any e-mails are discarded. [#discarded-emails]_

Account setup
^^^^^^^^^^^^^

To set up your e-mail account, log in to our :doc:`LDAP <./ldap>` host and
configure a forwarding e-mail.

.. todo:: Go more into detail here and add screenshots.


.. [#discarded-emails] In one condition e-mails will not be discarded: if
   the recipient is a member of the DevOps team and the recipient has no
   forwarding address configured, the e-mail will be delivered to the unix mbox
   of the recipient on our e-mail host itself.


Administration manual
---------------------

The following diagram showcases the current setup:

.. graphviz::

   graph email {
     sender [shape="star"]
     receiver [shape="star"]

     subgraph cluster_lovelace {
       label="lovelace.box.pydis.wtf"

       postfix
       policyd_spf [label="policyd-spf"]
       postsrsd
     }

     subgraph cluster_ldap {
       label="ldap01.box.pydis.wtf"

       ldapd
     }

     sender -- postfix [label="inbound e-mail", dir="forward"]
     postfix -- policyd_spf [label="check if SPF is valid", dir="forward"]
     postfix -- ldapd [label="query for user", dir="forward"]
     postfix -- postsrsd [label="set up temporary forwarding", dir="forward"]
     postfix -- receiver [label="forward e-mail", dir="forward"]
   }

Note that delivery to the unix mailbox on lovelace is also possible, but this
only applies to members who are in the DevOps role and do not have any external
mailbox configured.


General logging
^^^^^^^^^^^^^^^

``postfix`` logs a wealth of useful information. This can be queried using the
following command:

.. code-block:: shell

   sudo journalctl -xefu postfix@-

The ``@-`` part is required, as the standard postfix Debian installation allows
for a multi-instance deployment, and we use the default instance (named ``-``)
for our forwarding.
