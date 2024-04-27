---
title: Access table
date: 2022-09-18
description: |
  Who has access to what.
---


| **Resource** | **Description** | **Keyholders** |
|:------------:|:---------------:|:--------------:|
| Linode Kubernetes Cluster | The primary cluster where all resources are deployed. | Hassan, Joe, Chris, Leon, Sebastiaan, Johannes |
| Linode Dashboard | The online dashboard for managing and allocating resources from Linode. | Joe, Chris |
| Netcup Dashboard | The dashboard for managing and allocating resources from Netcup. | Joe, Chris |
| Netcup servers | Root servers provided by the Netcup partnership. | Joe, Chris, Hassan, Johannes |
| Grafana | The primary aggregation dashboard for most resources. | Admins, Moderators, Core Developers and DevOps (with varying permissions) |
| Prometheus Dashboard | The Prometheus query dashboard. Access is controlled via Cloudflare Access. | Hassan, Joe, Johannes, Chris |
| Alertmanager Dashboard | The alertmanager control dashboard. Access is controlled via Cloudflare Access. | Hassan, Joe, Johannes, Chris |
| `git-crypt`ed files in infra repository | `git-crypt` is used to encrypt certain files within the repository. At the time of writing this is limited to kubernetes secret files. | Chris, Joe, Hassan, Johannes, Xithrius |
| Ansible Vault | Used to store sensitive data for the Ansible deployment | Chris, Joe, Johannes, Bella |
