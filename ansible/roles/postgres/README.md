# Role "postgres"

Installs and configures the postgres cluster.


## Variables

- `postgres_version` The postgres version to be installed.
- `postgres_user` The user that owns root access to the postgres cluster
- `postgres_users` The list of postgres users that have restricted access to the postgres cluster. Each user needs to have
  the following attributes defined:
  - `name`: The user's login name
  - `password`: The user's password
  - `roles`: A list of roles that will be assigned to the user. You can read more about them here https://www.postgresql.org/docs/current/user-manag.html

- `postgres_hba_rules` The postgres cluster's host based authentication configuration.
   All the following attributes can be found in detail here https://www.postgresql.org/docs/current/auth-pg-hba-conf.html
  - `conn_type`: The connection type allowed to connect to the cluster.
  - `database`: The database that the user who's trying to connect is allowed to access.
  - `user`: The user's login name
  - `address`: The ip address or addresses to be allowed to connect from.
  - `method`: The login method.

- `postgres_databases` The list of databases that will be created in the cluster
  - `name`: The database's name
    `owner`: The owner of the database, this is equivalent to the `postgres_users.name`


`postgres_grants` The list of access privileges that will be granted to specific roles/users. You can read more about these
  In the official docs https://www.postgresql.org/docs/current/sql-grant.html
  The specific values these variables can take can be found here https://docs.ansible.com/ansible/latest/collections/community/postgresql/postgresql_privs_module.html
 - `roles`: Comma separated list of role (user/group) names to set permissions for.
 - `database`: Name of database to connect to.
 - `state`: The state of the privilege, `present` to grant them and `absent` to revoke them.
 - `privs`: Comma separated list of privileges to grant/revoke.
 - `objs`: Comma separated list of database objects to set privileges on.
