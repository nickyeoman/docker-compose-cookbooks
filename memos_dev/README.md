# Memos

## Overview

Memos is a self-hosted, lightweight note-taking and knowledge-base application with a focus on simplicity and privacy. This Docker Compose stack deploys Memos with persistent storage and an external reverse proxy.

## Project Details

-   **Project Repository:** [Memos](https://www.usememos.com)
-   **Container Image:** [Docker Hub](https://hub.docker.com/r/neosmemo/memos)
-   **Compose Example:** [Official Docs](https://www.usememos.com/docs/install/self-hosting)
-   **Documentation:** [Docs](https://www.usememos.com/docs)
-   **Reverse Proxy Port:** `5230`

## Getting Started

1. Copy `sample.env` to `.env` and edit values as needed
2. Start the stack: `docker compose up -d`
3. Open http://localhost:5230 in your browser
4. Create your admin account on first visit

## Environment Variable Notes

-   `VOL_PATH` – base path for persistent data (default: `/data`)
-   `MEMOS_IMAGE` – image tag (default: `neosmemo/memos:stable`)
-   `MEMOS_RESTART` – restart policy (default: `unless-stopped`)
-   `MEMOS_PORT` – host port (default: `5230`)

## Volume Notes

-   `${VOL_PATH:-/data}/memos` – SQLite database, uploads, and user data

## Network Notes

Requires the external `proxy` network.

## Docker Run

```bash
docker run -d \
  --name memos \
  -p 5230:5230 \
  -v /data/memos:/var/opt/memos \
  neosmemo/memos:stable
```

## Additional Notes / Gotchas

-   Memos uses SQLite by default — no external database needed.
-   All data is stored in the mounted volume. Back up regularly.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: memos
Compose file path: memos_dev/compose.yaml
Additional env file (optional): memos_dev/sample.env

Then "Load" memos_dev/sample.env into the Environmental variables in dockhand

Create the Stack
