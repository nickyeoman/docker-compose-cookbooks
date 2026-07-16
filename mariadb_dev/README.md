# MariaDB

Dockerhub: https://hub.docker.com/_/mariadb
Project: https://mariadb.org/
Proxy Port: 3306

It will be quite uncommon to just use this compose file, it's likely you are extending this from another project.
That's the main context of this container.

## Overview

Standalone MariaDB database server for stacks that need shared SQL.

## Project Details

-   **Container Image:** [mariadb:latest](https://hub.docker.com/_/mariadb)
-   **Reverse Proxy Port:** `3306`

## Getting Started

1. Start the container: `docker compose up -d`
2. Open http://localhost:3306 in your browser
3. Follow the initial setup wizard to configure the application

## Environment Variable Notes

    MARIADB_DATABASE – default: mydb
    MARIADB_ROOT_PASSWORD – default: ChangeThisPassword
    MARIADB_USER – default: dbuser
    MARIADB_PASSWORD – default: ChangeThisPassword
    MARIADB_PORT – default: 3306

## Volume Notes

    /var/lib/mysql – host path /data/mariadb

## Network Notes

Requires proxy network

## Docker Run

```bash
docker run -d \
  --name mariadb \
  -p 3306:3306 \
  -v /data/mariadb:/var/lib/mysql \
  mariadb:latest
```

See compose.yaml for the full set of environment variables.

## Additional Notes / Gotchas

Other stacks include their own database; this stack is for a shared or standalone instance.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: mariadb_dev
Compose file path: mariadb_dev/compose.yaml
Additional env file (optional): mariadb_dev/sample.env

Then "Load" mariadb_dev/sample.env into the Environmental variables in dockhand

Create the Stack

## Sample

### Run multiple databases 

initdb/init.sql

```sql

-- Create BookStack database and user
CREATE DATABASE IF NOT EXISTS bookstack_db;
CREATE USER IF NOT EXISTS 'bookstack_user'@'%' IDENTIFIED BY 'bookstack_password';
GRANT ALL PRIVILEGES ON bookstack_db.* TO 'bookstack_user'@'%';

-- Create WordPress database and user
CREATE DATABASE IF NOT EXISTS wordpress_db;
CREATE USER IF NOT EXISTS 'wordpress_user'@'%' IDENTIFIED BY 'wordpress_password';
GRANT ALL PRIVILEGES ON wordpress_db.* TO 'wordpress_user'@'%';

FLUSH PRIVILEGES;
```

### Change command

```yaml
# heimdall, pwigo
command: --max_allowed_packet=32505856
# monica
command: --transaction-isolation=READ-COMMITTED --binlog-format=ROW --innodb-file-per-table=1 --skip-innodb-read-only-compressed
# nextcloud
command: --transaction-isolation=READ-COMMITTED --log-bin=binlog --binlog-format=ROW
```
