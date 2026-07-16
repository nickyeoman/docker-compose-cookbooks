# Docmost

## Overview

Docmost is a collaborative wiki and documentation platform, similar to Notion or Outline. It supports real-time editing, page hierarchies, and rich content. This stack includes PostgreSQL for data storage and Redis for session management and caching.

## Project Details

- **Project Repository:** [https://docmost.com/](https://docmost.com/)
- **Container Image:** [docmost/docmost](https://hub.docker.com/r/docmost/docmost)
- **Reverse Proxy Port:** `3000` (internally), mapped to `8000` by default

## Getting Started

Open http://localhost:8000 in your browser:

1. Create your admin account on first visit
2. Start creating pages and organizing your workspace
3. Optionally configure SMTP in the compose environment for email invites

## Environment Variable Notes

| Variable | Description |
|---|---|
| `DOCMOST_IMAGE` | Docmost container image (default: `docmost/docmost:latest`) |
| `POSTGRES_IMAGE` | PostgreSQL image (default: `postgres:16-alpine`) |
| `REDIS_IMAGE` | Redis image (default: `redis:7-alpine`) |
| `DOCMOST_RESTART` | Restart policy for all services (default: `unless-stopped`) |
| `DOCMOST_PORT` | Published port for the web UI (default: `8000`) |
| `VOL_PATH` | Base path for persistent data volumes (default: `/data`) |
| `APP_URL` | Public-facing URL of your Docmost instance |
| `APP_SECRET` | Secret key used for encryption and sessions — generate a long random string |
| `DB_PASSWORD` | Password for the PostgreSQL database user |

## Volume Notes

| Volume | Purpose |
|---|---|
| `${VOL_PATH:-/data}/docmost/storage` | Docmost uploads and data storage |
| `${VOL_PATH:-/data}/docmost/db` | PostgreSQL database files |
| `${VOL_PATH:-/data}/docmost/redis` | Redis persistence data |

## Network Notes

- `proxy` — external network for reverse proxy access to the Docmost web UI
- `docmost_internal` — internal bridge network for communication between Docmost, PostgreSQL, and Redis

Create the proxy network once with:

```bash
docker network create proxy
```

## Docker Run

This is a multi-service stack — use `docker compose` instead of individual `docker run` commands.

## Additional Notes / Gotchas

Nothing specific to this stack so far.

## Dockhand Stack, Deploy from Git

- **Cookbooks Repository**
- **stackname:** docmost_dev
- **Compose file path:** docmost_dev/compose.yaml
- **Additional env file (optional):** docmost_dev/sample.env

Load `docmost_dev/sample.env` into the Environment variables in Dockhand, then create the Stack.
