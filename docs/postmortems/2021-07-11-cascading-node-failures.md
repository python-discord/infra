---
layout: default
title: "2021-07-11: Cascading node failures and ensuing volume problems"
parent: Postmortems
nav_order: 6
---

# 2021-07-11: Cascading node failures and ensuing volume problems

A PostgreSQL connection spike (00:27 UTC) caused by Django moved a node to an unresponsive state (00:55 UTC), upon performing a recycle of the affected node volumes were placed into a state where they could not be mounted.

# ⚠️ Leadup

*List the sequence of events that led to the incident*

- **00:27 UTC:** Django starts rapidly using connections to our PostgreSQL database
- **00:32 UTC:** DevOps team is alerted that PostgreSQL has saturated it's 115 max connections limit. Joe is paged.
- **00:33 UTC:** DevOps team is alerted that a service has claimed 34 dangerous table locks (it peaked at 61).
- **00:42 UTC:** Status incident created and backdated to 00:25 UTC. [Status incident](https://status.pythondiscord.com/incident/92712)
- **00:55 UTC:** It's clear that the node which PostgreSQL was on is no longer healthy after the Django connection surge, so it's recycled and a new one is to be added to the pool.
- **01:01 UTC:** Node `lke13311-16405-5fafd1b46dcf` begins it's restart
- **01:13 UTC:** Node has restored and regained healthy status, but volumes will not mount to the node. Support ticket opened at Linode for assistance.
- **06:36 UTC:** DevOps team alerted that Python is offline. This is due to Redis being a dependency of the bot, which as a stateful service was not healthy.

# 🥏 Impact

*Describe how internal and external users were impacted during the incident*

Initially, this manifested as a standard node outage where services on that node experienced some downtime as the node was restored.

Post-restore, all stateful services (e.g. PostgreSQL, Redis, PrestaShop) were unexecutable due to the volume issues, and so any dependent services (e.g. Site, Bot, Hastebin) also had trouble starting.

PostgreSQL was restored early on so for the most part Moderation could continue.

# 👁️ Detection

*Report when the team detected the incident, and how we could improve detection time*

DevOps were initially alerted at 00:32 UTC due to the PostgreSQL connection surge, and acknowledged at the same time.

Further alerting could be used to catch surges earlier on (looking at conn delta vs. conn total), but for the most part alerting time was satisfactory here.

# 🙋🏿‍♂️ Response

*Who responded to the incident, and what obstacles did they encounter?*

Joe Banks responded. The primary issue encountered was failure upstream at Linode to remount the affected volumes, a support ticket has been created.

# 🙆🏽‍♀️ Recovery

*How was the incident resolved? How can we improve future mitigation?*

Initial node restoration was performed by @Joe Banks by recycling the affected node.

Subsequent volume restoration was also @Joe Banks and once Linode had unlocked the volumes affected pods were scaled down to 0, the volumes were unmounted at the Linode side and then the deployments were recreated.

<details markdown="block">
<summary>Support ticket sent</summary>

<blockquote markdown="block">
Good evening,

We experienced a resource surge on one of our Kubernetes nodes at 00:32 UTC, causing a node to go unresponsive. To mitigate problems here the node was recycled and began restarting at 1:01 UTC.

The node has now rejoined the ring and started picking up services, but volumes will not attach to it, meaning pods with stateful storage will not start.

An example events log for one such pod:

```
  Type     Reason       Age    From               Message
  ----     ------       ----   ----               -------
  Normal   Scheduled    2m45s  default-scheduler  Successfully assigned default/redis-599887d778-wggbl to lke13311-16405-5fafd1b46dcf
  Warning  FailedMount  103s   kubelet            MountVolume.MountDevice failed for volume "pvc-bb1d06139b334c1f" : rpc error: code = Internal desc = Unable to find device path out of attempted paths: [/dev/disk/by-id/linode-pvcbb1d06139b334c1f /dev/disk/by-id/scsi-0Linode_Volume_pvcbb1d06139b334c1f]
  Warning  FailedMount  43s    kubelet            Unable to attach or mount volumes: unmounted volumes=[redis-data-volume], unattached volumes=[kube-api-access-6wwfs redis-data-volume redis-config-volume]: timed out waiting for the condition

```

I've been trying to manually resolve this through the Linode Web UI but get presented with attachment errors upon doing so. Please could you advise on the best way forward to restore Volumes & Nodes to a functioning state? As far as I can see there is something going on upstream since the Linode UI presents these nodes as mounted however as shown above LKE nodes are not locating them, there is also a few failed attachment logs in the Linode Audit Log.

Thanks,

Joe
</blockquote>
</details>

<details markdown="block">
<summary>Response received from Linode</summary>

<blockquote markdown="block">
Hi Joe,

> Were there any known issues with Block Storage in Frankfurt today?

Not today, though there were service issues reported for Block Storage and LKE in Frankfurt on July 8 and 9:

- [Service Issue - Block Storage - EU-Central (Frankfurt)](https://status.linode.com/incidents/pqfxl884wbh4)
- [Service Issue - Linode Kubernetes Engine - Frankfurt](https://status.linode.com/incidents/13fpkjd32sgz)

There was also an API issue reported on the 10th (resolved on the 11th), mentioned here:

- [Service Issue - Cloud Manager and API](https://status.linode.com/incidents/vhjm0xpwnnn5)

Regarding the specific error you were receiving:

> `Unable to find device path out of attempted paths`

I'm not certain it's specifically related to those Service Issues, considering this isn't the first time a customer has reported this error in their LKE logs. In fact, if I recall correctly, I've run across this before too, since our volumes are RWO and I had too many replicas in my deployment that I was trying to attach to, for example.

> is this a known bug/condition that occurs with Linode CSI/LKE?

From what I understand, yes, this is a known condition that crops up from time to time, which we are tracking. However, since there is a workaround at the moment (e.g. - "After some more manual attempts to fix things, scaling down deployments, unmounting at Linode and then scaling up the deployments seems to have worked and all our services have now been restored."), there is no ETA for addressing this. With that said, I've let our Storage team know that you've run into this, so as to draw further attention to it.

If you have any further questions or concerns regarding this, let us know.

Best regards,
[Redacted]

Linode Support Team
</blockquote>
</details>

<details markdown="block">
<summary>Concluding response from Joe Banks</summary>

<blockquote markdown="block">
Hey [Redacted]!

Thanks for the response. We ensure that stateful pods only ever have one volume assigned to them, either with a single replica deployment or a statefulset. It appears that the error generally manifests when a deployment is being migrated from one node to another during a redeploy, which makes sense if there is some delay on the unmount/remount.

Confusion occurred because Linode was reporting the volume as attached when the node had been recycled, but I assume that was because the node did not cleanly shutdown and therefore could not cleanly unmount volumes.

We've not seen any resurgence of such issues, and we'll address the software fault which overloaded the node which will helpfully mitigate such problems in the future.

Thanks again for the response, have a great week!

Best,

Joe
</blockquote>
</details>

# 🔎 Five Why's

*Run a 5-whys analysis to understand the true cause of the incident.*

### **What?**

Several of our services became unavailable because their volumes could not be mounted.

### Why?

A node recycle left the node unable to mount volumes using the Linode CSI.

### Why?

A node recycle was used because PostgreSQL had a connection surge.

### Why?

A Django feature deadlocked a table 62 times and suddenly started using ~70 connections to the database, saturating the maximum connections limit.

### Why?

The root cause of why Django does this is unclear, and someone with more Django proficiency is absolutely welcome to share any knowledge they may have. I presume it's some sort of worker race condition, but I've not been able to reproduce it.

# 🌱 Blameless root cause

*Note the final root cause and describe what needs to change to prevent reoccurrence*

A node being forcefully restarted left volumes in a limbo state where mounting was difficult, it took multiple hours for this to be resolved since we had to wait for the volumes to unlock so they could be cloned.

# 🤔 Lessons learned

*What did we learn from this incident?*

Volumes are painful.

We need to look at why Django is doing this and mitigations of the fault to prevent this from occurring again.

# ☑️ Follow-up tasks

*List any tasks we should complete that are relevant to this incident*

- [x] [Follow up on ticket at Linode](https://www.notion.so/Cascading-node-failures-and-ensuing-volume-problems-1c6cfdfcadfc4422b719a0d7a4cc5001)
- [ ]  Investigate why Django could be connection surging and locking tables
