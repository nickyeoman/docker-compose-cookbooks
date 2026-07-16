# Grocy

## Overview

Self-hosted grocery, household inventory, chores, and meal planning system.

## Project Details

-   **Project Repository:** [GitHub](https://github.com/grocy/grocy)
-   **Container Image:** [linuxserver/grocy](https://docs.linuxserver.io/images/docker-grocy/)
-   **Documentation:** [grocy.info](https://grocy.info/)
-   **Reverse Proxy Port:** `80`

## Getting Started

1. Start the container: `docker compose up -d`
2. Open http://localhost:9283 in your browser
3. Follow the initial setup wizard to configure the application

## Environment Variable Notes

    GROCY_PUID / GROCY_PGID – file ownership for the config volume

## Volume Notes

    /config – application data and SQLite database

## Network Notes

Requires proxy network

## Docker Run

```bash
docker run -d \
  --name grocy \
  -p 9283:80 \
  -e TZ=America/Vancouver -e PUID=1000 -e PGID=1000 \
  -v /data/grocy/config:/config \
  lscr.io/linuxserver/grocy:latest
```

## Additional Notes / Gotchas

Default login is admin/admin — change it after first login.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: grocy_dev
Compose file path: grocy_dev/compose.yaml
Additional env file (optional): grocy_dev/sample.env

Then "Load" grocy_dev/sample.env into the Environmental variables in dockhand

Create the Stack
