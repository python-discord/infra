---
description: Email services hosted by Python Discord
---
# Overview

This document describes the email setup for Python Discord.

Email has the following use-cases for Python Discord:

- Sending service mail to users such as password resets and notifications
- Providing forwarding mail for individual users who do not wish to expose their
  personal email addresses
- Providing forwarding mail for teams within staff (e.g. administrators, events
  team)

An overview of our email setup is shown below:

```mermaid
flowchart TD
    P[Postfix]
    L[LDAP]
    EX[/External Mail Gateways/]
    IX[/Inbound Mail/]
    DC[Dovecot]
    IM[/IMAP Mailboxes/]
    subgraph V[Validation Services]
    ODK[OpenDKIM]
    ODM[OpenDMARC]
    SPF[SPF]
    end

    IX-- Delivered to Postfix (SMTP or submission) -->P
    P-- Fetches user mail settings --> L
    P<-- Signs Outbound Mail --> ODK
    P-- Validates Inbound Mail ----> ODK
    P-- Validates Inbound Mail ----> ODM
    P-- Validates Inbound Mail ----> SPF
    P-- Sends Outbound Mail ---> EX
    P-- Forwards locally destined mail ---> DC
    DC-- Places mail into IMAP folders ---> IM
```

Find an overview of the services we use for email below:

- [Postfix](components/postfix.md)
- [LDAP](../LDAP/index.md)
- [OpenDKIM, OpenDMARC & SPF validation](components/validation.md)
- [DKIM signing](components/signing.md)
- [Dovecot](components/dovecot/index.md)
