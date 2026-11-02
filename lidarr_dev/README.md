# Lidarr

## Overview

Lidarr is a music collection manager for Usenet and BitTorrent users. It automatically monitors specified artists, searches for new releases (or upgrades to existing tracks), and sends them to your download client. After download, Lidarr renames and organizes the files into your music library and can notify your media server of the new content.

## Project Details

- **Project Repository:** [https://lidarr.audio/](https://lidarr.audio/)
- **Container Image:** [ghcr.io/hotio/lidarr](https://hotio.dev/containers/lidarr/)
- **Reverse Proxy Port:** `8686`

## Getting Started

### Prepare the shared media folder (once per host)

All media apps run as user `1000` and share `/data/media`. If Docker creates the folder itself it's owned by root, and the apps fail with *"Folder '/media/' is not writable by user 'hotio'"*. Create it with the right owner before first start:

```bash
sudo mkdir -p /data/media/{downloads/prowlarr,movies,shows,music,books}
sudo chown -R 1000:1000 /data/media
sudo chmod -R u+rwX,g+rwX /data/media
```

Check with `ls -ln /data/media` — the owner should be `1000 1000`.

Open http://localhost:8686 in your browser and complete the initial setup wizard:

1. **Choose your UI language**
2. **Add a download client** — select qBittorrent, enter its host/port/credentials
3. **Add an indexer** — or connect to Prowlarr for automatic indexer sync

Once the wizard finishes, Lidarr displays **"No artists found"**. To populate your library:

- Go to **Settings → Media Management** and add a **Root Folder** (e.g., `/media/music`) — this is where your organized music library will live
- Click **Add an artist** and search by name — Lidarr fetches metadata, discography, and album art
- Lidarr cross-references your Root Folder for any existing files and matches them to the artist's catalog

### Download flow

qBittorrent downloads to `/media/downloads/prowlarr` → Lidarr picks it up, renames/tags the files, and moves them into `<Root Folder>/Artist Name/Album/`

### Spotify playlist import

Lidarr doesn't natively import Spotify playlists. Use a community tool like [SpotifyToLidarr](https://github.com/Claudemirovsky/SpotifyToLidarr) or set up a **List** (Settings → Lists) from Last.fm or MusicBrainz to auto-add artists based on your listening habits.

## Environment Variable Notes

| Variable | Description |
|---|---|
| `LIDARR_IMAGE` | Container image (default: `ghcr.io/hotio/lidarr:release`) |
| `LIDARR_RESTART` | Restart policy (default: `unless-stopped`) |
| `LIDARR_PORT` | Published port for the web UI (default: `8686`) |
| `VOL_PATH` | Base path for persistent data volumes (default: `/data`) |
| `LIDARR_MEDIA` | Shared media root on the host (default: `/data/media`), mounted at `/media`. Must be the same folder qBittorrent, Sonarr, Radarr and Jellyfin use |
| `TZ` | Container timezone (default: `America/Vancouver`) |

## Volume Notes

| Volume | Purpose |
|---|---|
| `${VOL_PATH:-/data}/lidarr/config` | Application configuration and database |
| `${LIDARR_MEDIA:-/data/media}` → `/media` | Shared media root: downloads in `/media/downloads`, library in `/media/music` |

## Network Notes

Requires an external `proxy` network. Create it once with:

```bash
docker network create proxy
```

## Docker Run

```bash
docker run -d \
  --name=lidarr \
  -e PUID=1000 \
  -e PGID=1000 \
  -e UMASK=002 \
  -e TZ=America/Vancouver \
  -p 8686:8686 \
  -v ${VOL_PATH:-/data}/lidarr/config:/config \
  -v ${LIDARR_MEDIA:-/data/media}:/media \
  --network proxy \
  --restart unless-stopped \
  ghcr.io/hotio/lidarr:release
```

## Additional Notes / Gotchas

- **One shared media folder.** qBittorrent, Sonarr, Radarr, Lidarr and Jellyfin all use `/data/media` on the host, mounted at `/media`, so a download has the same path in every container: no Remote Path Mapping needed, and imports can use hardlinks. Enable **Settings → Media Management → Use Hardlinks instead of Copy**.
- **Layout:** `/data/media/downloads/prowlarr` (qBittorrent category `prowlarr`), `/data/media/music` (Lidarr root, Jellyfin's `/music` library).
- In the qBittorrent download client settings, set **Category** to `prowlarr`.

## Dockhand Stack, Deploy from Git

- **Cookbooks Repository**
- **stackname:** lidarr_dev
- **Compose file path:** lidarr_dev/compose.yaml
- **Additional env file (optional):** lidarr_dev/sample.env

Load `lidarr_dev/sample.env` into the Environment variables in Dockhand, then create the Stack.
