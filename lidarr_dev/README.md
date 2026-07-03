# Lidarr

## Overview

Lidarr is a music collection manager for Usenet and BitTorrent users. It automatically monitors specified artists, searches for new releases (or upgrades to existing tracks), and sends them to your download client. After download, Lidarr renames and organizes the files into your music library and can notify your media server of the new content.

## Getting Started

Open http://localhost:8686 in your browser and complete the initial setup wizard:

1. **Choose your UI language**
2. **Add a download client** — select qBittorrent, enter its host/port/credentials
3. **Add an indexer** — or connect to Prowlarr for automatic indexer sync

Once the wizard finishes, Lidarr displays **"No artists found"**. To populate your library:

- Go to **Settings → Media Management** and add a **Root Folder** (e.g., `/music`) — this is where your organized music library will live
- Click **Add an artist** and search by name — Lidarr fetches metadata, discography, and album art
- Lidarr cross-references your Root Folder for any existing files and matches them to the artist's catalog

### Download flow

qBittorrent downloads to its own directory → Lidarr picks it up, renames/tags the files, and moves them into `<Root Folder>/Artist Name/Album/`

### Spotify playlist import

Lidarr doesn't natively import Spotify playlists. Use a community tool like [SpotifyToLidarr](https://github.com/Claudemirovsky/SpotifyToLidarr) or set up a **List** (Settings → Lists) from Last.fm or MusicBrainz to auto-add artists based on your listening habits.

## Docker Run

```bash
docker run -d \
  --name=lidarr \
  -e PUID=1000 \
  -e PGID=1000 \
  -e UMASK=002 \
  -e TZ=America/Vancouver \
  -p 8686:8686 \
  -v ${VOL_PATH:-./data}/lidarr/config:/config \
  -v ${VOL_PATH:-./data}/lidarr/data:/data \
  --network proxy \
  --restart unless-stopped \
  ghcr.io/hotio/lidarr:release
```

## Project Details

- **Project Repository:** [https://lidarr.audio/](https://lidarr.audio/)
- **Container Image:** [ghcr.io/hotio/lidarr](https://hotio.dev/containers/lidarr/)
- **Reverse Proxy Port:** `8686`

## Environment Variable Notes

| Variable | Description |
|---|---|
| `LIDARR_IMAGE` | Container image (default: `ghcr.io/hotio/lidarr:release`) |
| `LIDARR_RESTART` | Restart policy (default: `unless-stopped`) |
| `LIDARR_PORT` | Published port for the web UI (default: `8686`) |
| `VOL_PATH` | Base path for persistent data volumes (default: `./data`) |
| `TZ` | Container timezone (default: `America/Vancouver`) |

## Volume Notes

| Volume | Purpose |
|---|---|
| `${VOL_PATH}/lidarr/config` | Application configuration and database |
| `${VOL_PATH}/lidarr/data` | Download client data and working directory |

## Network Notes

Requires an external `proxy` network. Create it once with:

```bash
docker network create proxy
```

## Dockhand Stack, Deploy from Git

- **Cookbooks Repository**
- **stackname:** lidarr_dev
- **Compose file path:** lidarr_dev/compose.yaml
- **Additional env file (optional):** lidarr_dev/sample.env

Load `lidarr_dev/sample.env` into the Environment variables in Dockhand, then create the Stack.
