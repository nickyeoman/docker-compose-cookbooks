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

- Go to **Settings → Media Management** and add a **Root Folder** (e.g., `/media/shows`) — this is where your organized TV library will live
- Click **Add Series** and search by title — Sonarr fetches metadata, posters, and available releases
- Optionally connect a **List** (Trakt, IMDb, etc.) to auto-import series from your watchlists

### Download flow

qBittorrent downloads to `/media/downloads/prowlarr` → Sonarr picks it up, renames the file, and moves it into `<Root Folder>/Series Name/Season XX/`

## Environment Variable Notes

| Variable | Description |
|---|---|
| `SONARR_IMAGE` | Container image (default: `ghcr.io/hotio/sonarr:release`) |
| `SONARR_RESTART` | Restart policy (default: `unless-stopped`) |
| `SONARR_PORT` | Published port for the web UI (default: `8989`) |
| `VOL_PATH` | Base path for persistent data volumes (default: `/data`) |
| `SONARR_MEDIA` | Shared media root on the host (default: `/data/media`), mounted at `/media`. Must be the same folder qBittorrent, Radarr and Jellyfin use |
| `TZ` | Container timezone (default: `America/Vancouver`) |

## Volume Notes

| Volume | Purpose |
|---|---|
| `${VOL_PATH:-/data}/sonarr/config` | Application configuration and database |
| `${SONARR_MEDIA:-/data/media}` → `/media` | Shared media library, kept separate from `VOL_PATH` since it's typically mounted into Sonarr, Radarr, Bazarr, and Jellyfin/etc. |

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
  -v ${SONARR_MEDIA:-/data/media}:/media \
  --network proxy \
  --restart unless-stopped \
  ghcr.io/hotio/sonarr:release
```

## Additional Notes / Gotchas

- **One shared media folder.** qBittorrent, Sonarr, Radarr and Jellyfin all use `/data/media` on the host. qBittorrent, Sonarr and Radarr mount it at `/media`, so a download has the same path in every container: no Remote Path Mapping needed, and imports can use hardlinks (instant, no extra disk space). Enable **Settings → Media Management → Use Hardlinks instead of Copy**.
- **Layout:** `/data/media/downloads/prowlarr` (qBittorrent category `prowlarr`), `/data/media/shows` (Sonarr), `/data/media/movies` (Radarr). The `shows`/`movies` names match the Jellyfin stack's library mounts.
- In the qBittorrent download client settings, set **Category** to `prowlarr`.

## Dockhand Stack, Deploy from Git

- **Cookbooks Repository**
- **stackname:** sonarr
- **Compose file path:** sonarr/compose.yaml
- **Additional env file (optional):** sonarr/sample.env

Load `sonarr/sample.env` into the Environment variables in Dockhand, then create the Stack.
