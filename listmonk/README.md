# listmonk

## Overview

Self-hosted newsletter and mailing list manager powered by PostgreSQL.
This stack deploys listmonk with persistent storage, automatic database
initialization/upgrades, and support for reverse proxy integration.

## Project Details

-   **Project Repository:** https://github.com/knadh/listmonk
-   **Container Image:** https://hub.docker.com/r/listmonk/listmonk
-   **Compose Example:** https://github.com/knadh/listmonk/blob/master/docker-compose.yml
-   **Documentation:** https://listmonk.app/docs/
-   **Reverse Proxy Port:** `9000` (configurable with `LISTMONK_PORT`)

## Getting Started

1. Start the container: `docker compose up -d`
2. Open http://localhost:9000 in your browser
3. Follow the initial setup wizard to configure the application

## Environment Variable Notes

Most variables are optional because sane defaults are already included
in the compose file.

### Database

    POSTGRES_IMAGE – PostgreSQL container image
    POSTGRES_RESTART – Restart policy for PostgreSQL
    POSTGRES_USER – PostgreSQL username
    POSTGRES_PASSWORD – PostgreSQL password
    POSTGRES_DB – PostgreSQL database name

### listmonk

    LISTMONK_IMAGE – listmonk container image
    LISTMONK_RESTART – Restart policy for listmonk
    LISTMONK_PORT – Web UI / proxy port
    LISTMONK_HOSTNAME – Container hostname
    LISTMONK_SSLMODE – PostgreSQL SSL mode
    LISTMONK_MAX_OPEN – Maximum open DB connections
    LISTMONK_MAX_IDLE – Maximum idle DB connections
    LISTMONK_MAX_LIFETIME – DB connection lifetime

### Initial Admin User

These are only used during first startup.

    LISTMONK_ADMIN_USER – Initial admin username
    LISTMONK_ADMIN_PASSWORD – Initial admin password

### General

    VOL_PATH – Base path for persistent storage
    TZ – Container timezone

## Volume Notes

/data/listmonk/db
        PostgreSQL database storage

    /data/listmonk/uploads
        listmonk uploads and media storage

Back up both directories regularly.

## Network Notes

Requires an external Docker network named:

    proxy

Create it manually if it does not already exist:

```bash
docker network create proxy
```

Internal application traffic uses the private:

    listmonk

bridge network.

## Docker Run

```bash
docker run -d \
  --name listmonk \
  -p 9000:9000 \
  -v /data/listmonk/db:/var/lib/postgresql \
  -v /data/listmonk/uploads:/listmonk/uploads:rw \
  listmonk/listmonk:latest
```

See compose.yaml for the full set of environment variables.

## Additional Notes / Gotchas

-   The stack automatically runs:

    - database installation
    - schema upgrades
    - application startup

    on container launch.

-   The install and upgrade commands are idempotent and safe to rerun.

-   Change all default passwords before exposing publicly.

-   Designed for use behind a reverse proxy such as Traefik, Caddy,
    Nginx Proxy Manager, or SWAG.

## Dockhand Stack, Deploy from Git

Cookbooks Repository

    stackname: listmonk
    Compose file path: listmonk/compose.yaml
    Additional env file (optional): listmonk/sample.env

Then load:

    listmonk/sample.env

into the Environmental Variables section in Dockhand.

Create the Stack.
