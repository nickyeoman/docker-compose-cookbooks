# HedgeDoc

## Overview

HedgeDoc is a self-hosted collaborative markdown editor for creating and sharing real-time notes and documentation. This Docker Compose stack deploys HedgeDoc with SQLite storage and an external reverse proxy.

## Project Details

-   **Project Repository:** [HedgeDoc](https://hedgedoc.org)
-   **Container Image:** [GitHub Container Registry](https://github.com/orgs/hedgedoc/packages)
-   **Compose Example:** [Official Docs](https://docs.hedgedoc.org)
-   **Documentation:** [Docs](https://docs.hedgedoc.org)
-   **Reverse Proxy Port:** `3000`

## Getting Started

1. Copy `sample.env` to `.env` and edit values as needed
2. Start the stack: `docker compose up -d`
3. Open http://localhost:3000 in your browser

## Environment Variable Notes

-   `VOL_PATH` – base path for persistent data (default: `/data`)
-   `HEDGEDOC_IMAGE` – image tag (default: `ghcr.io/hedgedoc/hedgedoc:latest`)
-   `HEDGEDOC_RESTART` – restart policy (default: `unless-stopped`)
-   `HEDGEDOC_PORT` – host port (default: `3000`)
-   `HEDGEDOC_DOMAIN` – server domain (default: `localhost`)
-   `HEDGEDOC_SSL` – enable HTTPS (default: `false`)
-   `HEDGEDOC_ADDPORT` – append port to URL (default: `true`)

## Volume Notes

-   `${VOL_PATH:-/data}/hedgedoc/data` – SQLite database and uploads

## Network Notes

Requires the external `proxy` network.

## Docker Run

```bash
docker run -d \
  --name hedgedoc \
  -p 3000:3000 \
  -e CMD_DB_URL=sqlite:///data/hedgedoc.db \
  -e CMD_DOMAIN=localhost \
  -v /data/hedgedoc/data:/hedgedoc/data \
  ghcr.io/hedgedoc/hedgedoc:latest
```

## Additional Notes / Gotchas

-   Uses SQLite by default. For PostgreSQL, add `CMD_DB_URL=postgres://...` and a `postgres` service.
-   For production, set `CMD_DOMAIN` to your actual domain and `CMD_PROTOCOL_USESSL=true`.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: hedgedoc
Compose file path: hedgedoc_dev/compose.yaml
Additional env file (optional): hedgedoc_dev/sample.env

Then "Load" hedgedoc_dev/sample.env into the Environmental variables in dockhand

Create the Stack
