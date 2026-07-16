# Open Archiver

## Overview

Self-hosted email archiving platform with full-text search.

## Project Details

-   **Container Image:** [logiclabshq/open-archiver:latest](https://hub.docker.com/r/logiclabshq/open-archiver)
-   **Reverse Proxy Port:** `3000`

## Getting Started

1. Start the container: `docker compose up -d`
2. Open http://localhost:3000 in your browser
3. Follow the initial setup wizard to configure the application

## Environment Variable Notes

    POSTGRES_DB – default: open_archive
    POSTGRES_USER – default: admin
    POSTGRES_PASSWORD – default: ChangeThisPassword
    REDIS_PASSWORD – default: ChangeThisPassword
    MEILI_MASTER_KEY – default: ChangeThisPassword
    NODE_ENV – default: production
    PORT_BACKEND – default: 4000
    PORT_FRONTEND – default: 3000
    SYNC_FREQUENCY – default: * * * * *
    MEILI_HOST – default: http://meilisearch:7700
    MEILI_INDEXING_BATCH – default: 500
    REDIS_HOST – default: valkey
    REDIS_PORT – default: 6379
    REDIS_TLS_ENABLED – default: false
    (see sample.env for the full list)

## Volume Notes

    /var/lib/postgresql/data – host path /data/openarchiver/pgdata
    /data – host path /data/openarchiver/valkeydata
    /meili_data – host path /data/openarchiver/meilidata
    /var/data/open-archiver – host path /data/openarchiver/archiver-data

## Network Notes

Requires proxy network

## Docker Run

```bash
docker run -d \
  --name openarchiver \
  -p 3000:3000 \
  -v /data/openarchiver/pgdata:/var/lib/postgresql/data \
  -v /data/openarchiver/valkeydata:/data \
  -v /data/openarchiver/meilidata:/meili_data \
  -v /data/openarchiver/archiver-data:/var/data/open-archiver \
  logiclabshq/open-archiver:latest
```

See compose.yaml for the full set of environment variables.

## Additional Notes / Gotchas

Nothing specific to this stack so far.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: openarchiver_dev
Compose file path: openarchiver_dev/compose.yaml
Additional env file (optional): openarchiver_dev/sample.env

Then "Load" openarchiver_dev/sample.env into the Environmental variables in dockhand

Create the Stack

## First Run

Will give you a chance to setup a new user.

You can add an ingestion source and it just starts importing.
