# Mariadb

Dockerhub: https://hub.docker.com/_/mariadb
Proxy Port: 3306

It will be quite uncommon to just use this compose file, it's likely you are extending this from another project.
That's the main context of this container.

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
```