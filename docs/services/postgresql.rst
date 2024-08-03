PostgreSQL
==========

Our main PostgreSQL instance runs on lovelace. This is our only supported PostgreSQL
instance and managed by DevOps.

.. contents::
   :depth: 3


User manual
-----------

Connections to the PostgreSQL database are performed from any applications in
the Kubernetes cluster to the FQDN of the host, ``lovelace.box.pydis.wtf``.  To
use the database in your app, please request an account and database from
DevOps.

Backups are performed regularly via `blackbox
<https://github.com/lemonsaurus/blackbox>`__, if you need data recovery, please
get in touch with the DevOps team.


Administration manual
---------------------

This section is for the DevOps team and includes technical documentation related
to management of our PostgreSQL instance.

Upgrading PostgreSQL
^^^^^^^^^^^^^^^^^^^^

The following documents how to upgrade the **major** version of our PostgreSQL
database, minor version upgrades are taken care of by regular OS updates on
lovelace.

Step 1 - Enable maintenance mode
********************************

Add a worker route for ``pythondiscord.com/*`` to forward to the
``maintenance`` Cloudflare worker.

Step 2 - Scale down all services that use PostgreSQL
****************************************************

Notably site, metricity, bitwarden and the like should be scaled down.

Services that are read only such as Grafana (but NOT Metabase, Metabase
uses PostgreSQL for internal storage) do not need to be scaled down, as
they do not update the database in any way.

.. code:: bash

   $ kubectl scale deploy --replicas 0 site metricity metabase bitwarden ...

Step 3 - Take a database dump and gzip
**************************************

Using ``pg_dumpall``, dump the contents of all databases to a ``.sql``
file.

Make sure to gzip for faster transfer.

Take a SHA512 sum of the output ``.sql.gz`` file to validate integrity
after copying.

.. code:: bash

   $ pg_dumpall -U pythondiscord > backup.sql
   $ gzip backup.sql
   $ sha512sum backup.sql
   a3337bfc65a072fd93124233ac1cefcdfbe8a708e5c1d08adaca2cf8c7cbe9ae4853ffab8c5cfbe943182355eaa701012111a420b29cc4f74d1e87f9df3af459  backup.sql

Step 4 - Move database dump locally
***********************************

Use ``kubectl cp`` to move the ``backup.sql.gz`` file from the remote
pod to your local machine.

Validate the integrity of the received file.

Step 5 - Attempt local import to new PostgreSQL version
*******************************************************

Install the new version of PostgreSQL locally and import the data. Make
sure you are operating on a **completely empty database server.**

.. code:: bash

   $ gzcat backup.sql.gz | psql -U joe

You can use any PostgreSQL superuser for the import. Ensure that no
errors other than those mentioned below occur, you may need to attempt
multiple times to fix errors listed below.

Handle import errors
~~~~~~~~~~~~~~~~~~~~

Monitor the output of ``psql`` to check that no errors appear.

If you receive locale errors ensure that the locale your database is
configured with matches the import script, this may require some usage
of ``sed``:

.. code:: bash

   $ sed -i '' "s/en_US.utf8/en_GB.UTF-8/g" backup.sql

Ensure that you **RESET THESE CHANGES** before attempting an import on
the remote, if they come from the PostgreSQL Docker image they will need
the same locale as the export.

Step 7 - Spin down PostgreSQL
*****************************

Spin down PostgreSQL to 0 replicas.

Step 8 - Take volume backup at Linode
*************************************

Backup the volume at Linode through a clone in the Linode UI, name it
something obvious.

Step 9 - Remove the Linode persistent volume
********************************************

Delete the volume specified in the ``volume.yaml`` file in the
``postgresql`` directory, you must delete the ``pvc`` first followed by
the ``pv``, you can find the relevant disks through
``kubectl get pv/pvc``

Step 10 - Create a new volume by re-applying the ``volume.yaml`` file
*********************************************************************

Apply the ``volume.yaml`` so a new, empty, volume is created.

Step 11 - Bump the PostgreSQL version in the ``deployment.yaml`` file
*********************************************************************

Update the Docker image used in the deployment manifest.

Step 12 - Apply the deployment
******************************

Run ``kubectl apply -f postgresql/deployment.yaml`` to start the new
database server.

Step 13 - Copy the data across
******************************

After the pod has initialised use ``kubectl cp`` to copy the gzipped
backup to the new Postgres pod.

Step 14 - Extract and import the new data
*****************************************

.. code:: bash

   $ gunzip backup.sql.gz
   $ psql -U pythondiscord -f backup.sql

Step 15 - Validate data import complete
***************************************

Ensure that all logs are successful, you may get duplicate errors for
the ``pythondiscord`` user and database, these are safe to ignore.

Step 16 - Scale up services
***************************

Restart the database server

.. code:: bash

   $ kubectl scale deploy --replicas 1 metricity bitwarden metabase

Step 17 - Validate all services interact correctly
**************************************************

Validate that all services reconnect successfully and start exchanging
data, ensure that no abnormal logs are outputted and performance remains
as expected.
