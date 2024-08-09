---
description: LDAP services hosted by Python Discord
---
# Overview

This document describes the LDAP setup for Python Discord. We use LDAP to manage
user accounts and permissions for our services.

We deploy several services to manage our LDAP, a brief overview of how they
interact is shown below:

```mermaid
flowchart TD
    subgraph internal[Internal Services]

    subgraph ldap[LDAP services]
    FIPA[("FreeIPA")]
    KC[Keycloak]

    KC-- Authenticates with LDAP -->FIPA
    end

    KA[King Arthur]-- Updates users -->FIPA
    KA-- Updates users -->KC

    G["Grafana (and others)"]-- Authenticates with LDAP --->FIPA

    subgraph mail[Mail]
    P[Postfix]-- Fetches user mail settings --> FIPA
    S[SASLAuthD]-- Authenticates users with LDAP ---> FIPA
    S<-- Authenticates Users -->P
    end
    end

    subgraph ext[External Services]
    CA[Cloudflare Access]-- Authenticates with SAML ----> KC
    end
```

## Services

LDAP services are provided by:

- [FreeIPA](components/freeipa.md)
- [Keycloak](components/keycloak.md)
