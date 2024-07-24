2020-12-11: Postgres connection surge
=====================================

At **13:24 UTC,** we noticed the bot was not able to infract, and
`pythondiscord.com <http://pythondiscord.com>`__ was unavailable. The
DevOps team started to investigate.

We discovered that Postgres was not accepting new connections because it
had hit 100 clients. This made it unavailable to all services that
depended on it.

Ultimately this was resolved by taking down Postgres, remounting the
associated volume, and bringing it back up again.

⚠️ Leadup
---------

*List the sequence of events that led to the incident*

The bot infractions stopped working, and we started investigating.

🥏 Impact
---------

*Describe how internal and external users were impacted during the
incident*

Services were unavailable both for internal and external users.

-  The Help Channel System was unavailable.
-  Voice Gate and Server Gate were not working.
-  Moderation commands were unavailable.
-  Python Discord site & API were unavailable. CloudFlare automatically
   switched us to Always Online.

👁️ Detection
------------

*Report when the team detected the incident, and how we could improve
detection time*

We noticed HTTP 524s coming from CloudFlare, upon attempting database
connection we observed the maximum client limit.

We noticed this log in site:

.. code:: yaml

   django.db.utils.OperationalError: FATAL:  sorry, too many clients already

We should be monitoring number of clients, and the monitor should alert
us when we’re approaching the max. That would have allowed for earlier
detection, and possibly allowed us to prevent the incident altogether.

We will look at
`wrouesnel/postgres_exporter <https://github.com/wrouesnel/postgres_exporter>`__
for monitoring this.

🙋🏿‍♂️ Response
----------------

*Who responded to the incident, and what obstacles did they encounter?*

Joe Banks responded to the incident. The obstacles were mostly a lack of
a clear response strategy.

We should document our recovery procedure so that we’re not so dependent
on Joe Banks should this happen again while he’s unavailable.

🙆🏽‍♀️ Recovery
----------------

*How was the incident resolved? How can we improve future mitigation?*

-  Delete PostgreSQL deployment ``kubectl delete deployment/postgres``
-  Delete any remaining pods, WITH force.
   ``kubectl delete <pod name> --force --grace-period=0``
-  Unmount volume at Linode
-  Remount volume at Linode
-  Reapply deployment ``kubectl apply -f postgres/deployment.yaml``

🔎 Five Why’s
-------------

*Run a 5-whys analysis to understand the true cause of the incident.*

-  Postgres was unavailable, so our services died.
-  **Why?** Postgres hit max clients, and could not respond.
-  **Why?** Unknown, but we saw a number of connections from previous
   deployments of site. This indicates that database connections are not
   being terminated properly. Needs further investigation.

🌱 Blameless root cause
-----------------------

*Note the final root cause and describe what needs to change to prevent
reoccurrance*

We’re not sure what the root cause is, but suspect site is not
terminating database connections properly in some cases. We were unable
to reproduce this problem.

We’ve set up new telemetry on Grafana with alerts so that we can
investigate this more closely. We will be let know if the number of
connections from site exceeds 32, or if the total number of connections
exceeds 90.

🤔 Lessons learned
------------------

*What did we learn from this incident?*

-  We must ensure the DevOps team has access to Linode and other key
   services even if our Bitwarden is down.
-  We need to ensure we’re alerted of any risk factors that have the
   potential to make Postgres unavailable, since this causes a
   catastrophic outage of practically all services.
-  We absolutely need backups for the databases, so that this sort of
   problem carries less of a risk.
-  We may need to consider something like
   `pg_bouncer <https://wiki.postgresql.org/wiki/PgBouncer>`__ to manage
   a connection pool so that we don’t exceed 100 *legitimate* clients
   connected as we connect more services to the postgres database.

☑️ Follow-up tasks
------------------

*List any tasks we should complete that are relevant to this incident*

-  ☒ All database backup
