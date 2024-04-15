# Metabase
These manifests provision an instance of Metabase, our database analysis tool.

## Secrets
A single secret of name `metabase-env` is used with the following values:

| Environment  | Description                               |
|--------------|-------------------------------------------|
| MB_DB_DBNAME | Database name for internal metabase usage |
| MB_DB_HOST   | Address of PostgreSQL database            |
| MB_DB_TYPE   | Always postgres                           |
| MB_DB_PASS   | Database user password                    |
| MB_DB_PORT   | Always 5432                               |
| MB_DB_USER   | User for metabase internal                |
