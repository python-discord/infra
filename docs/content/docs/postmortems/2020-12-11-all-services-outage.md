---
title: "2020-12-11: All services outage"
---

# 2020-12-11: All services outage

At **19:55 UTC, all services became unresponsive**. The DevOps were already in a call, and immediately started to investigate.

Postgres was running at 100% CPU usage due to a **VACUUM**, which caused all services that depended on it to stop working. The high CPU left the host unresponsive and it shutdown. Linode Lassie noticed this and triggered a restart.

It did not recover gracefully from this restart, with numerous core services reporting an error, so we had to manually restart core system services using Lens in order to get things working again.

## ⚠️ Leadup

*List the sequence of events that led to the incident*

Postgres triggered a **AUTOVACUUM**, which lead to a CPU spike. This made Postgres run at 100% CPU and was unresponsive, which caused services to stop responding. This lead to a  restart of the node, from which we did not recover gracefully.

## 🥏 Impact

*Describe how internal and external users were impacted during the incident*

All services went down. Catastrophic failure. We did not pass go, we did not collect $200.

- Help channel system unavailable, so people are not able to effectively ask for help.
- Gates unavailable, so people can't successfully get into the community.
- Moderation and raid prevention unavailable, which leaves us defenseless against attacks.

## 👁️ Detection

*Report when the team detected the incident, and how we could improve detection time*

We noticed that all PyDis services had stopped responding, coincidentally our DevOps team were in a call at the time, so that was helpful.

We may be able to improve detection time by adding monitoring of resource usage. To this end, we've added alerts for high CPU usage and low memory.

## 🙋🏿‍♂️ Response

*Who responded to the incident, and what obstacles did they encounter?*

Joe Banks responded to the incident.

We noticed our node was entirely unresponsive and within minutes a restart had been triggered by Lassie after a high CPU shutdown occurred.

The node came back and we saw a number of core services offline (e.g. Calico, CoreDNS, Linode CSI).

**Obstacle: no recent database back-up available**

## 🙆🏽‍♀️ Recovery

*How was the incident resolved? How can we improve future mitigation times?*

Through [Lens](https://k8slens.dev/) we restarted core services one by one until they stabilised, after these core services were up other services began to come back online.

We finally provisioned PostgreSQL which had been removed as a component before the restart (but too late to prevent the CPU errors). Once PostgreSQL was up we restarted any components that were acting buggy (e.g. site and bot).

## 🔎 Five Why's

*Run a 5-whys analysis to understand the true cause of the incident.*

- Major service outage
- **Why?** Core service failures (e.g. Calico, CoreDNS, Linode CSI)
- **Why?** Kubernetes worker node restart
- **Why?** High CPU shutdown
- **Why?** Intensive PostgreSQL AUTOVACUUM caused a CPU spike

## 🌱 Blameless root cause

*Note the final root cause and describe what needs to change to prevent reoccurrance*

## 🤔 Lessons learned

*What did we learn from this incident?*

- We must ensure we have working database backups. We are lucky that we did not lose any data this time. If this problem had caused volume corruption, we would be screwed.
- Sentry is broken for the bot. It was missing a DSN secret, which we have now restored.
- The [https://sentry.pydis.com](https://sentry.pydis.com) redirect was never migrated to the cluster. **We should do that.**

## ☑️ Follow-up tasks

*List any tasks we've created as a result of this incident*

- [x] Push forward with backup plans
