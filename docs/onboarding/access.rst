Access table
============

+--------------------+-------------------------+-----------------------+
| **Resource**       | **Description**         | **Keyholders**        |
+====================+=========================+=======================+
| Linode Kubernetes  | The primary cluster     | Hassan, Joe, Chris,   |
| Cluster            | where all resources are | Leon, Sebastiaan,     |
|                    | deployed.               | Johannes              |
+--------------------+-------------------------+-----------------------+
| Linode Dashboard   | The online dashboard    | Joe, Chris            |
|                    | for managing and        |                       |
|                    | allocating resources    |                       |
|                    | from Linode.            |                       |
+--------------------+-------------------------+-----------------------+
| Netcup Dashboard   | The dashboard for       | Joe, Chris            |
|                    | managing and allocating |                       |
|                    | resources from Netcup.  |                       |
+--------------------+-------------------------+-----------------------+
| Netcup servers     | Root servers provided   | Joe, Chris, Bella,    |
|                    | by the Netcup           | Johannes              |
|                    | partnership.            |                       |
+--------------------+-------------------------+-----------------------+
| Grafana            | The primary aggregation | Admins, Moderators,   |
|                    | dashboard for most      | Core Developers and   |
|                    | resources.              | DevOps (with varying  |
|                    |                         | permissions)          |
+--------------------+-------------------------+-----------------------+
| Prometheus         | The Prometheus query    | Hassan, Joe,          |
| Dashboard          | dashboard. Access is    | Johannes, Chris       |
|                    | controlled via          |                       |
|                    | Cloudflare Access.      |                       |
+--------------------+-------------------------+-----------------------+
| Alertmanager       | The alertmanager        | Hassan, Joe,          |
| Dashboard          | control dashboard.      | Johannes, Chris       |
|                    | Access is controlled    |                       |
|                    | via Cloudflare Access.  |                       |
+--------------------+-------------------------+-----------------------+
| ``git-crypt``\ ed  | ``git-crypt`` is used   | Chris, Joe, Hassan,   |
| files in infra     | to encrypt certain      | Johannes, Xithrius    |
| repository         | files within the        |                       |
|                    | repository. At the time |                       |
|                    | of writing this is      |                       |
|                    | limited to kubernetes   |                       |
|                    | secret files.           |                       |
+--------------------+-------------------------+-----------------------+
| Ansible Vault      | Used to store sensitive | Chris, Joe, Johannes, |
|                    | data for the Ansible    | Bella                 |
|                    | deployment              |                       |
+--------------------+-------------------------+-----------------------+
