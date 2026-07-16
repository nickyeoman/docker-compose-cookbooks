# Sonarr

## Overview

Sonarr is an automated TV series collection manager for Usenet and BitTorrent users. It monitors your shows for new episodes, scans configured indexers for releases, and sends matches to your download client. After download, it renames and organizes episodes into series/season folders and notifies your media server.

## Project Details

- **Project Repository:** [https://sonarr.tv/](https://sonarr.tv/)
- **Container Image:** [ghcr.io/hotio/sonarr](https://hotio.dev/containers/sonarr/)
- **Reverse Proxy Port:** `8989`

## Getting Started

Open http://localhost:8989 in your browser and complete the initial setup wizard:

1. **Choose your UI language**
2. **Add a download client** — select qBittorrent, enter its host/port/credentials
3. **Add an indexer** — or connect to Prowlarr for automatic indexer sync

Once the wizard finishes, you'll see an empty library. To populate it:

- Go to **Settings → Media Management** and add a **Root Folder** (e.g., `/tv`) — this is where your organized TV library will live
- Click **Add Series** and search by title — Sonarr fetches metadata, posters, and available releases
- Optionally connect a **List** (Trakt, IMDb, etc.) to auto-import series from your watchlists

### Download flow

qBittorrent downloads to its own directory → Sonarr picks it up, renames the file, and moves it into `<Root Folder>/Series Name/Season XX/`

## Environment Variable Notes

| Variable | Description |
|---|---|
| `SONARR_IMAGE` | Container image (default: `ghcr.io/hotio/sonarr:release`) |
| `SONARR_RESTART` | Restart policy (default: `unless-stopped`) |
| `SONARR_PORT` | Published port for the web UI (default: `8989`) |
| `VOL_PATH` | Base path for persistent data volumes (default: `/data`) |
| `TZ` | Container timezone (default: `America/Vancouver`) |

## Volume Notes

| Volume | Purpose |
|---|---|
| `${VOL_PATH:-/data}/sonarr/config` | Application configuration and database |
| `${VOL_PATH:-/data}/sonarr/data` | Download client data and working directory |

## Network Notes

Requires an external `proxy` network. Create it once with:

```bash
docker network create proxy
```

## Docker Run

```bash
docker run -d \
  --name=sonarr \
  -e PUID=1000 \
  -e PGID=1000 \
  -e UMASK=002 \
  -e TZ=America/Vancouver \
  -p 8989:8989 \
  -v ${VOL_PATH:-/data}/sonarr/config:/config \
  -v ${VOL_PATH:-/data}/sonarr/data:/data \
  --network proxy \
  --restart unless-stopped \
  ghcr.io/hotio/sonarr:release
```

## Additional Notes / Gotchas

Nothing specific to this stack so far.

## Dockhand Stack, Deploy from Git

- **Cookbooks Repository**
- **stackname:** sonarr_dev
- **Compose file path:** sonarr_dev/compose.yaml
- **Additional env file (optional):** sonarr_dev/sample.env

Load `sonarr_dev/sample.env` into the Environment variables in Dockhand, then create the Stack.
