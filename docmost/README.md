# Docmost

## Overview

Docmost is a collaborative wiki and documentation platform, similar to Notion or Outline. It supports real-time editing, page hierarchies, and rich content. This stack includes PostgreSQL for data storage and Redis for session management and caching.

## Project Details

- **Project Repository:** [https://docmost.com/](https://docmost.com/)
- **Container Image:** [docmost/docmost](https://hub.docker.com/r/docmost/docmost)
- **Reverse Proxy Port:** `3000` (internally), mapped to `8000` by default

## Getting Started

Open http://localhost:8000 in your browser:

1. In `sample.env`, set `APP_SECRET` (at least 32 characters — `openssl rand -hex 32`), `DB_PASSWORD`, and `APP_URL` to your public URL (e.g. `https://docs.example.com`)
2. Deploy the stack and open the site — on first visit you create the workspace and admin account
3. Start creating spaces and pages

## Environment Variable Notes

| Variable | Description |
|---|---|
| `DOCMOST_IMAGE` | Docmost container image (default: `docmost/docmost:latest`) |
| `POSTGRES_IMAGE` | PostgreSQL image (default: `postgres:16-alpine`) |
| `REDIS_IMAGE` | Redis image (default: `redis:7-alpine`) |
| `DOCMOST_RESTART` | Restart policy for all services (default: `unless-stopped`) |
| `DOCMOST_PORT` | Published port for the web UI (default: `8000`) |
| `VOL_PATH` | Base path for persistent data volumes (default: `/data`) |
| `APP_URL` | Public-facing URL of your Docmost instance (used in links and invites; must match the URL you browse to) |
| `APP_SECRET` | Secret key for encryption and sessions — **must be at least 32 characters** or Docmost will refuse to start (`openssl rand -hex 32`) |
| `DB_PASSWORD` | Password for the PostgreSQL database user |

## Volume Notes

| Volume | Purpose |
|---|---|
| `${VOL_PATH:-/data}/docmost/storage` | Docmost uploads and data storage |
| `${VOL_PATH:-/data}/docmost/db` | PostgreSQL database files |
| `${VOL_PATH:-/data}/docmost/redis` | Redis persistence data |

## Network Notes

- `proxy` — external network for reverse proxy access to the Docmost web UI
- `internal` — bridge network for Docmost ↔ PostgreSQL/Redis; the database and Redis are only on this network

Create the proxy network once with:

```bash
docker network create proxy
```

## Docker Run

This is a multi-service stack — use `docker compose` instead of individual `docker run` commands.

## Additional Notes / Gotchas

- **`APP_SECRET` length:** the default `ChangeThisPassword` is too short on purpose — the container won't start until you set a real 32+ character secret.
- **Reverse proxy:** in Nginx Proxy Manager point the host at `docmost:3000` and enable **Websockets Support** — real-time collaborative editing depends on it.
- **Email (invites, password reset):** not configured by default. Add `MAIL_DRIVER=smtp`, `SMTP_HOST`, `SMTP_PORT`, `SMTP_USERNAME`, `SMTP_PASSWORD`, `MAIL_FROM_ADDRESS`, `MAIL_FROM_NAME` to the `docmost` service environment — see the [Docmost docs](https://docmost.com/docs/self-hosting/environment-variables).
- **Postgres upgrades:** don't bump `POSTGRES_IMAGE` major versions (e.g. 16 → 17) on an existing data dir; dump and restore instead.

## Dockhand Stack, Deploy from Git

- **Cookbooks Repository**
- **stackname:** docmost
- **Compose file path:** docmost/compose.yaml
- **Additional env file (optional):** docmost/sample.env

Load `docmost/sample.env` into the Environment variables in Dockhand, then create the Stack.
