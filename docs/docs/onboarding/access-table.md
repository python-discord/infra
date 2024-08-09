---
description: The Access Table breaks down the different DevOps resources available and who has access to them.
---
# Access Table

## Compute

| **Resource**                            | **Description**                                                         | **Keyholders**                                 |
| --------------------------------------- | ----------------------------------------------------------------------- | ---------------------------------------------- |
| Linode Kubernetes Cluster               | The primary cluster where all resources are deployed.                   | Hassan, Joe, Chris, Leon, Sebastiaan, Johannes |
| Linode Dashboard                        | The online dashboard for managing and allocating resources from Linode. | Joe, Chris                                     |
| Netcup Dashboard                        | The dashboard for managing and allocating resources from Netcup.        | Joe, Chris                                     |
| Netcup servers                          | Root servers provided by the Netcup partnership.                        | Joe, Chris, Bella, Johannes                    |

## Secrets

| **Resource**                            | **Description**                                                     | **Keyholders**                                |
| --------------------------------------- | ------------------------------------------------------------------- | --------------------------------------------- |
| `git-crypt`ed files in infra repository | `git-crypt` is used to encrypt certain files within the repository. | Chris, Joe, Hassan, Johannes, Bella, Xithrius |
| Ansible Vault                           | Used to store sensitive data for the Ansible deployment             | Chris, Joe, Johannes, Bella                   |

## Services

Additionally, several services are gated behind membership of the `DevOps` role
on Discord, sign in is handled by Cloudflare Access &
[LDAP](../services/LDAP/index.md):

- Prometheus
- AlertManager
- Grafana (also open to Core Developers, Moderators and Administrators)
