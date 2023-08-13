---
layout: default
title: "2021-01-10: Primary Kubernetes node outage"
parent: Postmortems
nav_order: 3
---

# 2021-01-10: Primary Kubernetes node outage


We had an outage of our highest spec node due to CPU exhaustion. The outage lasted from around 20:20 to 20:46 UTC, but was not a full service outage.

## ⚠️ Leadup

*List the sequence of events that led to the incident*

I ran a query on Prometheus to try figure out some statistics on the number of metrics we are holding, this ended up scanning a lot of data in the TSDB database that Prometheus uses.

This scan caused a CPU exhaustion which caused issues with the Kubernetes node status.

## 🥏 Impact

*Describe how internal and external users were impacted during the incident*

This brought down the primary node which meant there was some service outage. Most services transferred successfully to our secondary node which kept up some key services such as the Moderation bot and Modmail bot, as well as MongoDB.

## 👁️ Detection

*Report when the team detected the incident, and how we could improve detection time*

This was noticed when Discord services started having failures. The primary detection was through alerts though! I was paged 1 minute after we started encountering CPU exhaustion issues.

## 🙋🏿‍♂️ Response

*Who responded to the incident, and what obstacles did they encounter?*

Joe Banks responded to the incident.

No major obstacles were encountered during this.

## 🙆🏽‍♀️ Recovery

*How was the incident resolved? How can we improve future mitigation?*

It was noted that in the response to `kubectl get nodes` the primary node's status was reported as `NotReady`. Looking into the reason it was because the node had stopped responding.

The quickest way to fix this was triggering a node restart. This shifted a lot of pods over to node 2 which encountered some capacity issues since it's not as highly specified as the first node.

I brought this back the first node by restarting it at Linode's end. Once this node was reporting as `Ready` again I drained the second node by running `kubectl drain lke13311-20304-5ffa4d11faab`. This command stops the node from being available for scheduling and moves existing pods onto other nodes.

Services gradually recovered as the dependencies started. The incident lasted overall around 26 minutes, though this was not a complete outage for the whole time and the bot remained functional throughout (meaning systems like the help channels were still functional).

## 🔎 Five Why's

*Run a 5-whys analysis to understand the true cause of the incident.*

**Why?** Partial service outage

**Why?** We had a node outage.

**Why?** CPU exhaustion of our primary node.

**Why?** Large prometheus query using a lot of CPU.

**Why?** Prometheus had to scan millions of TSDB records which consumed all cores.

## 🌱 Blameless root cause

*Note the final root cause and describe what needs to change to prevent reoccurrance*

A large query was run on Prometheus, so the solution is just to not run said queries.

To protect against this more precisely though we should write resource constraints for services like this that are vulnerable to CPU exhaustion or memory consumption, which are the causes of our two past outages as well.

## 🤔 Lessons learned

*What did we learn from this incident?*

- Don't run large queries, it consumes CPU!
- Write resource constraints for our services.

## ☑️ Follow-up tasks

*List any tasks we should complete that are relevant to this incident*

- [x]  Write resource constraints for our services.
