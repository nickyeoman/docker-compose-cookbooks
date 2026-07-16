# Radarr

## Overview

Radarr is an automated movie collection manager for Usenet and BitTorrent users. It monitors your watchlist (from Trakt, IMDb, etc.), scans configured indexers for releases, and sends matches to your download client. After download, it renames and organizes files into your movie library and notifies your media server.

## Project Details

- **Project Repository:** [https://radarr.video/](https://radarr.video/)
- **Container Image:** [ghcr.io/hotio/radarr](https://hotio.dev/containers/radarr/)
- **Reverse Proxy Port:** `7878`

## Getting Started

Open http://localhost:7878 in your browser and complete the initial setup wizard:

1. **Choose your UI language**
2. **Add a download client** — select qBittorrent, enter its host/port/credentials
3. **Add an indexer** — or connect to Prowlarr for automatic indexer sync

Once the wizard finishes, you'll see an empty library. To populate it:

- Go to **Settings → Media Management** and add a **Root Folder** (e.g., `/movies`) — this is where your organized movie library will live
- Click **Add Movie** and search by title — Radarr fetches metadata, posters, and available releases
- Optionally connect a **List** (Trakt, IMDb, etc.) to auto-import movies from your watchlists

### Download flow

qBittorrent downloads to its own directory → Radarr picks it up, renames the file, and moves it into `<Root Folder>/Movie Name (Year)/`

## Environment Variable Notes

| Variable | Description |
|---|---|
| `RADARR_IMAGE` | Container image (default: `ghcr.io/hotio/radarr:release`) |
| `RADARR_RESTART` | Restart policy (default: `unless-stopped`) |
| `RADARR_PORT` | Published port for the web UI (default: `7878`) |
| `VOL_PATH` | Base path for persistent data volumes (default: `/data`) |
| `TZ` | Container timezone (default: `America/Vancouver`) |

## Volume Notes

| Volume | Purpose |
|---|---|
| `${VOL_PATH:-/data}/radarr/config` | Application configuration and database |
| `${VOL_PATH:-/data}/radarr/data` | Download client data and working directory |

## Network Notes

Requires an external `proxy` network. Create it once with:

```bash
docker network create proxy
```

## Docker Run

```bash
docker run -d \
  --name=radarr \
  -e PUID=1000 \
  -e PGID=1000 \
  -e UMASK=002 \
  -e TZ=America/Vancouver \
  -p 7878:7878 \
  -v ${VOL_PATH:-/data}/radarr/config:/config \
  -v ${VOL_PATH:-/data}/radarr/data:/data \
  --network proxy \
  --restart unless-stopped \
  ghcr.io/hotio/radarr:release
```

## Additional Notes / Gotchas

Nothing specific to this stack so far.

## Dockhand Stack, Deploy from Git

- **Cookbooks Repository**
- **stackname:** radarr_dev
- **Compose file path:** radarr_dev/compose.yaml
- **Additional env file (optional):** radarr_dev/sample.env

Load `radarr_dev/sample.env` into the Environment variables in Dockhand, then create the Stack.
