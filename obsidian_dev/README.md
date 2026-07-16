# Obsidian

## Overview

Local-first note-taking and knowledge management app, run as a web-accessible desktop via KasmVNC.

## Project Details

-   **Project Repository:** [obsidian.md](https://obsidian.md/)
-   **Container Image:** [linuxserver/obsidian](https://docs.linuxserver.io/images/docker-obsidian/)
-   **Documentation:** [help.obsidian.md](https://help.obsidian.md/)
-   **Reverse Proxy Port:** `3000`

## Getting Started

1. Start the container: `docker compose up -d`
2. Open http://localhost:3000 in your browser
3. Follow the initial setup wizard to configure the application

## Environment Variable Notes

    OBSIDIAN_PUID / OBSIDIAN_PGID – ownership of the vault files

## Volume Notes

    /config – Obsidian settings and your vaults

## Network Notes

Requires proxy network

## Docker Run

```bash
docker run -d \
  --name obsidian \
  -p 3000:3000 \
  -e TZ=America/Vancouver -e PUID=1000 -e PGID=1000 \
  -v /data/obsidian/config:/config \
  lscr.io/linuxserver/obsidian:latest
```

## Additional Notes / Gotchas

This streams the Obsidian desktop app to your browser (KasmVNC) — it is unauthenticated by default, so keep it behind the proxy with auth. Obsidian itself is proprietary (free for personal use).

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: obsidian_dev
Compose file path: obsidian_dev/compose.yaml
Additional env file (optional): obsidian_dev/sample.env

Then "Load" obsidian_dev/sample.env into the Environmental variables in dockhand

Create the Stack
