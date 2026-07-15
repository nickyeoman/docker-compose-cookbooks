# Adminer

## Overview

Adminer is a full-featured database management tool in a single PHP file. This stack runs Adminer with a tmpfs-backed PHP session directory — no persistent storage required.

## Project Details

-   **Project Repository:** [https://github.com/vrana/adminer](https://github.com/vrana/adminer)
-   **Container Image:** [Docker Hub](https://hub.docker.com/_/adminer)
-   **Documentation:** [https://www.adminer.org/](https://www.adminer.org/)
-   **Reverse Proxy Port:** `8080`

## Getting Started

1. Start the container: `docker compose up -d`
2. Open http://localhost:${ADMINER_PORT:-8082} and enter your database credentials

## Environment Variable Notes

    ADMINER_DEFAULT_SERVER – default database host shown in the login form (default: mariadb)

## Volume Notes

No persistent volumes — PHP session data is stored on a tmpfs mount.

## Network Notes

Requires the external `proxy` network (Nginx Proxy Manager). An internal bridge network `internal` is available for connecting to database containers.

## Docker Run

```bash
docker run -d \
  --name adminer \
  --tmpfs /var/lib/php:rw,noexec,nosuid,size=64M \
  -e ADMINER_DEFAULT_SERVER=mariadb \
  -p 8082:8080 \
  --network proxy \
  adminer:latest
```

## Additional Notes / Gotchas

- Adminer is a single-script PHP app with no config file — all settings are passed via environment variables at runtime.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: ADMINER_DEV
Compose file path: adminer_dev/compose.yaml
Additional env file (optional): adminer_dev/sample.env

Then "Load" adminer_dev/sample.env into the Environmental variables in dockhand

Create the Stack
