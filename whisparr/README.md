# Whisparr

## Overview

Whisparr is an automated adult content collection manager for Usenet and BitTorrent users. It monitors your watchlist, scans configured indexers for releases, and sends matches to your download client. After download, it renames and organizes files into your media library and can notify your media server.

## Project Details

- **Project Repository:** [https://whisparr.com/](https://whisparr.com/)
- **Container Image:** [ghcr.io/hotio/whisparr](https://hotio.dev/containers/whisparr/)
- **Reverse Proxy Port:** `6969`

## Getting Started

### Prepare the shared media folder (once per host)

All media apps run as user `1000` and share `/data/media`. If Docker creates the folder itself it's owned by root, and the apps fail with *"Folder '/media/' is not writable by user 'hotio'"*. Create it with the right owner before first start:

```bash
sudo mkdir -p /data/media/{downloads/prowlarr,movies,shows,music,books,adult}
sudo chown -R 1000:1000 /data/media
sudo chmod -R u+rwX,g+rwX /data/media
```

Check with `ls -ln /data/media` — the owner should be `1000 1000`.

Open http://localhost:6969 in your browser and complete the initial setup wizard:

1. **Choose your UI language**
2. **Add a download client** — select qBittorrent, enter its host/port/credentials
3. **Add an indexer** — or connect to Prowlarr for automatic indexer sync

Once the wizard finishes, you'll see an empty library. To populate it:

- Go to **Settings → Media Management** and add a **Root Folder** `/media/adult` — Stash sees this same folder at `/adult`
- Click **Add Movie** and search by title — Whisparr fetches metadata and available releases
- Optionally connect a **List** to auto-import from your watchlists

### Download flow

qBittorrent downloads to `/media/downloads/prowlarr` → Whisparr picks it up, renames the file, and moves it into `<Root Folder>/Title (Year)/`

## Environment Variable Notes

| Variable | Description |
|---|---|
| `WHISPARR_IMAGE` | Container image (default: `ghcr.io/hotio/whisparr:release`) |
| `WHISPARR_RESTART` | Restart policy (default: `unless-stopped`) |
| `WHISPARR_PORT` | Published port for the web UI (default: `6969`) |
| `VOL_PATH` | Base path for persistent data volumes (default: `/data`) |
| `WHISPARR_MEDIA` | Shared media root on the host (default: `/data/media`), mounted at `/media`. Downloads land in `/media/downloads/prowlarr`, library in `/media/adult` |
| `TZ` | Container timezone (default: `America/Vancouver`) |

## Volume Notes

| Volume | Purpose |
|---|---|
| `${VOL_PATH:-/data}/whisparr/config` | Application configuration and database |
| `${WHISPARR_MEDIA:-/data/media}` → `/media` | Shared media root: downloads in `/media/downloads/prowlarr`, library in `/media/adult` |

## Network Notes

Requires an external `proxy` network. Create it once with:

```bash
docker network create proxy
```

## Docker Run

```bash
docker run -d \
  --name=whisparr \
  -e PUID=1000 \
  -e PGID=1000 \
  -e UMASK=002 \
  -e TZ=America/Vancouver \
  -p 6969:6969 \
  -v ${VOL_PATH:-/data}/whisparr/config:/config \
  -v ${WHISPARR_MEDIA:-/data/media}:/media \
  --network proxy \
  --restart unless-stopped \
  ghcr.io/hotio/whisparr:release
```

## Additional Notes / Gotchas

- **Works with Stash, not Jellyfin.** Whisparr's library is `/data/media/adult` on the host. The Stash stack mounts that same folder at `/adult` (`STASH_ADULT_PATH`), so in Stash add **`/adult`** as a library path (Settings → Library). Jellyfin doesn't mount it.
- **One shared media folder.** qBittorrent and Whisparr both mount `/data/media` at `/media`, so download paths match (no Remote Path Mapping) and imports can use hardlinks. Enable **Settings → Media Management → Use Hardlinks instead of Copy**.
- **Rescan after import.** Turn on a scheduled library scan in Stash (or scan manually) so new imports show up.
- In the qBittorrent download client settings, set **Category** to `prowlarr`.

## Dockhand Stack, Deploy from Git

- **Cookbooks Repository**
- **stackname:** whisparr
- **Compose file path:** whisparr/compose.yaml
- **Additional env file (optional):** whisparr/sample.env

Load `whisparr/sample.env` into the Environment variables in Dockhand, then create the Stack.
