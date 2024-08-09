---
description: An overview of FreeIPA, the identity management solution used by Python Discord
---
# FreeIPA

FreeIPA is an open-source identity management solution that provides a
centralized authentication, authorization, and account information by storing
data about user, groups, hosts, and other objects necessary to manage the
security of a network of computers.

We interface with FreeIPA from other services using LDAP.

## User

Users will rarely have to interface with FreeIPA directly. Most interactions
with FreeIPA will be done through other services such as
[Keycloak](./keycloak.md) or via the [Discord integrations](../discord-ldap.md).

Nonetheless, users can access the FreeIPA web interface at
[ldap01.box.pydis.wtf](https://ldap01.box.pydis.wtf), though most users will
experience TLS errors due to the self-signed certificate that IPA runs with.

All common user tasks can be accomplished through the Keycloak interface, so it
is recommended to use that instead.

## DevOps Team

### Deployment Information

FreeIPA is deployed to it's own Linux host running Rocky Linux. User access is
controlled by LDAP itself so providing you have a valid SSH key and are in the
correct DevOps groups (as managed by King Arthur), you will be able to SSH into
this host.

### User Accounts vs. Service Accounts

FreeIPA stores both user accounts for our staff team, as well as service
accounts for our various services. Service accounts are used for a variety of
things, such as:

- Keycloak authenticating users against LDAP and syncing user data
- Grafana authenticating users against LDAP
- Bitwarden sending email
- Postfix authenticating users against LDAP and fetching user mail settings

Service accounts are not synced with Discord or Keycloak and exist only in the
LDAP directory, since they do not match a Discord user and do not need SAML or
OpenID authentication.

Service accounts can be identified by their emails ending in `@int.pydis.wtf`
instead of `@pydis.wtf`. This is very important as it is how Keycloak decides
which users to sync.

### Common Tasks

Maintenance of FreeIPA is done through the FreeIPA web interface, accessible at
[ldap01.box.pydis.wtf](https://ldap01.box.pydis.wtf).

Through this user interface you can access the raw information that is stored on
the LDAP server, as well as manage users, groups, and other objects.

#### Renaming a User

Due to the way that users are uniquely identified across the domain by their
Discord username, it is not directly possible to rename a user in FreeIPA.

The simplest way for a user to change their username is to delete and recreate
the account manually, as opposed to the bootstrapping by King Arthur.

To do this, follow these steps:

1. Log into the FreeIPA web interface at
   [ldap01.box.pydis.wtf](https://ldap01.box.pydis.wtf) using your LDAP
   credentials.
1. Delete the user account by selecting the user and clicking the delete button.

    !!! warning "User data migration"

        Since there is no way for services using the LDAP server to know that the user has been renamed, the user will have to reconfigure their accounts in services such as Grafana, Keycloak and others authenticating against the LDAP directory.

        You should warn the user of this consequence beforehand and ensure they are prepared to reconfigure their accounts.

1. Recreate the user account, setting the following preferences:

    | Field             | Value                                                          |
    | ----------------- | -------------------------------------------------------------- |
    | User login        | The users preferred login, i.e. `joe`                          |
    | First & Last Name | Set the users Discord username as both the first and last name |
    | New Password      | This can be a randomly generated password.                     |

    !!! note "User passwords"

        Note that whilst it is required to set a password here, this is not the password you should give to the user.

        Once the account has been created, instruct the user to navigate to the `#ldap` channel in Discord and request
        a self-service password reset. This will allow the user to set their own password.

1. Select "Add & Edit" to create the user account.
1. Correct the display name generated to match the users Discord username. They
   will be able to change this themselves later.
1. __IMPORTANTLY:__ Fill in the `Employee Number` field with the users Discord
   ID.

!!! tip "The `Employee Number` field"

    This field is what is used by King Arthur to link accounts between Discord and LDAP. If this field is not set, the user will not be able to authenticate against LDAP and synchronization will not work. King Arthur will abort synchronisations if user accounts are not correctly configured.

Once you have completed these stages, as mentioned above instruct the user to
navigate to the `#ldap` channel in Discord and request a self-service password
reset. King Arthur should echo back to them their new `@pydis.wtf` account with
the amended username and a temporary password.

#### Creating a service account

Service accounts exist only in FreeIPA and so must be created there.

To create a service account, follow these steps:

1. Log into the FreeIPA web interface at
   [ldap01.box.pydis.wtf](https://ldap01.box.pydis.wtf) using your LDAP
   credentials.
1. Click on the Create User button.
1. Fill in the following fields:

    | Field             | Value                                                           |
    | ----------------- | --------------------------------------------------------------- |
    | User login        | The service account name, i.e. `grafana`                        |
    | First & Last Name | Set the service name as both the first and last name            |
    | New Password      | This can be a randomly generated password. Take note of it now. |

1. Select "Add & Edit" to create the user account.
1. Correct the display name generated to match the service name.
1. __IMPORTANTLY:__ Update the email to end in `@int.pydis.wtf`.

    !!! danger

        It is important to update this field, otherwise the service account will not gain all service account privileges such as mail sending and Keycloak will complain about the user not existing on Discord.
