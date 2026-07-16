# Zammad

Proxy port: 8080 on zammad-nginx

Zammad has good support for their own repo, probably better to use that one.
This is just Zammad for my own 

Official Documenation: https://docs.zammad.org/en/latest/install/docker-compose.html

Official Repository: https://github.com/zammad/zammad-docker-compose/blob/master/docker-compose.yml

```bash
mkdir -p data/elasticsearch
chown -R 1000:1000 data/
chmod -R 755 data/elasticsearch/
```

## Overview

Helpdesk and ticketing system with web, email, and chat channels.

## Project Details

-   **Container Image:** [ghcr.io/zammad/zammad:latest](https://github.com/zammad/zammad)
-   **Reverse Proxy Port:** `8080`

## Getting Started

1. Start the container: `docker compose up -d`
2. Open http://localhost:8080 in your browser
3. Follow the initial setup wizard to configure the application

## Environment Variable Notes

    POSTGRES_VERSION – default: 17.5-alpine
    POSTGRES_DB – default: zammad_production
    POSTGRES_USER – default: zammad
    POSTGRES_PASS – default: ChangeThisPassword
    REDIS_VERSION – default: 7.4.5-alpine
    MEMCACHE_VERSION – default: 1.6.39-alpine
    ELASTICSEARCH_VERSION – default: 8.19.2
    ELASTICSEARCH_JAVA_OPTS – default: -Xms1g -Xmx1g
    MEMCACHE_SERVERS – default: zammad-memcached:11211
    POSTGRES_HOST – default: zammad-postgresql
    POSTGRES_PORT – default: 5432
    POSTGRESQL_OPTIONS – default: ?pool=50
    POSTGRESQL_DB_CREATE – default: true
    REDIS_URL – default: redis://zammad-redis:6379
    (see sample.env for the full list)

## Volume Notes

    /var/lib/postgresql/data – host path /data/zammad/postgresql
    /data – host path /data/zammad/redis
    /data – host path /data/zammad/memcached
    /usr/share/elasticsearch/data – host path /data/zammad/elasticsearch
    /opt/zammad/storage – host path /data/zammad/storage
    /opt/zammad/storage – host path /data/zammad/storage
    /opt/zammad/storage – host path /data/zammad/storage
    /opt/zammad/storage – host path /data/zammad/storage
    /var/tmp/zammad – host path /data/zammad/backup
    /opt/zammad/storage – host path /data/zammad/storage
    /opt/zammad/storage – host path /data/zammad/storage

## Network Notes

Requires proxy network

## Docker Run

```bash
docker run -d \
  --name zammad \
  -p 8080:8080 \
  -v /data/zammad/postgresql:/var/lib/postgresql/data \
  -v /data/zammad/redis:/data \
  -v /data/zammad/memcached:/data \
  -v /data/zammad/elasticsearch:/usr/share/elasticsearch/data \
  -v /data/zammad/storage:/opt/zammad/storage \
  ghcr.io/zammad/zammad:latest
```

See compose.yaml for the full set of environment variables.

## Additional Notes / Gotchas

The zammad-init service intentionally uses `restart: on-failure` (one-shot init container).

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: zammad_dev
Compose file path: zammad_dev/compose.yaml
Additional env file (optional): zammad_dev/sample.env

Then "Load" zammad_dev/sample.env into the Environmental variables in dockhand

Create the Stack
