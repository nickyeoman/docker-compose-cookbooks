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

- Go to **Settings → Media Management** and add a **Root Folder** (e.g., `/media/movies`) — this is where your organized movie library will live
- Click **Add Movie** and search by title — Radarr fetches metadata, posters, and available releases
- Optionally connect a **List** (Trakt, IMDb, etc.) to auto-import movies from your watchlists

### Download flow

qBittorrent downloads to `/media/downloads/prowlarr` → Radarr picks it up, renames the file, and moves it into `<Root Folder>/Movie Name (Year)/`

## Environment Variable Notes

| Variable | Description |
|---|---|
| `RADARR_IMAGE` | Container image (default: `ghcr.io/hotio/radarr:release`) |
| `RADARR_RESTART` | Restart policy (default: `unless-stopped`) |
| `RADARR_PORT` | Published port for the web UI (default: `7878`) |
| `VOL_PATH` | Base path for persistent data volumes (default: `/data`) |
| `RADARR_MEDIA` | Shared media root on the host (default: `/data/media`), mounted at `/media`. Must be the same folder qBittorrent, Sonarr and Jellyfin use |
| `TZ` | Container timezone (default: `America/Vancouver`) |

## Volume Notes

| Volume | Purpose |
|---|---|
| `${VOL_PATH:-/data}/radarr/config` | Application configuration and database |
| `${RADARR_MEDIA:-/data/media}` → `/media` | Shared media library, kept separate from `VOL_PATH` since it's typically mounted into Sonarr, Radarr, Bazarr, and Jellyfin/etc. |

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
  -v ${RADARR_MEDIA:-/data/media}:/media \
  --network proxy \
  --restart unless-stopped \
  ghcr.io/hotio/radarr:release
```

## Additional Notes / Gotchas

- **One shared media folder.** qBittorrent, Sonarr, Radarr and Jellyfin all use `/data/media` on the host. qBittorrent, Sonarr and Radarr mount it at `/media`, so a download has the same path in every container: no Remote Path Mapping needed, and imports can use hardlinks (instant, no extra disk space). Enable **Settings → Media Management → Use Hardlinks instead of Copy**.
- **Layout:** `/data/media/downloads/prowlarr` (qBittorrent category `prowlarr`), `/data/media/shows` (Sonarr), `/data/media/movies` (Radarr). The `shows`/`movies` names match the Jellyfin stack's library mounts.
- In the qBittorrent download client settings, set **Category** to `prowlarr`.

## Dockhand Stack, Deploy from Git

- **Cookbooks Repository**
- **stackname:** radarr
- **Compose file path:** radarr/compose.yaml
- **Additional env file (optional):** radarr/sample.env

Load `radarr/sample.env` into the Environment variables in Dockhand, then create the Stack.
