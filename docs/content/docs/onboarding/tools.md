---
title: Tools
date: 2022-09-18
description: |
  The tools that DevOps uses to run their shop.
---

# Tools

We use a few tools to manage, monitor, and interact with our infrastructure.
Some of these tools are not unique to the DevOps team, and may be shared by
other teams.

Most of these are gated behind a Cloudflare Access system, which is accessible
to the [DevOps Team](https://github.com/orgs/python-discord/teams/devops) on
GitHub. These are marked with the ☁️ emoji. If you don’t have access, please
contact Chris or Joe.

## [Grafana](https://grafana.pydis.wtf/)

Grafana provides access to some of the most important resources at your
disposal. It acts as an aggregator and frontend for a large amount of data.
These range from metrics, to logs, to stats. Some of the most important are
listed below:

- Service Logs/All App Logs Dashboard

    Service logs is a simple log viewer which gives you access to a large
    majority of the applications deployed in the default namespace. The All App
    logs dashboard is an expanded version of that which gives you access to all
    apps in all namespaces, and allows some more in-depth querying.

- Kubernetes Dashboard

    This dashboard gives quick overviews of all the most important metrics of
    the Kubernetes system. For more detailed information, check out other
    dashboard such as Resource Usage, NGINX, and Redis.


Accessed via a GitHub login, with permission for anyone in the dev-core or
dev-ops team.

## [Prometheus Dashboard](https://prometheus.pydis.wtf/) (☁️))

This provides access to the Prometheus query console. You may also enjoy the
[Alertmanager Console](https://alertmanager.pydis.wtf/).

## [King Arthur](https://github.com/python-discord/king-arthur/)

King Arthur is a discord bot which provides information about, and access to
our cluster directly in discord. Invoke its help command for more information
(`M-x help`).
