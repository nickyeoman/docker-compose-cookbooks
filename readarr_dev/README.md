# Readarr

## Overview

Readarr is an automated eBook and audiobook collection manager for Usenet and BitTorrent users. It monitors authors on your watchlist, scans configured indexers for new releases or upgrades, and sends them to your download client. After download, it renames and organizes files into your book library and can notify your media server.

## Project Details

- **Project Repository:** [https://readarr.com/](https://readarr.com/)
- **Container Image:** [ghcr.io/hotio/readarr](https://hotio.dev/containers/readarr/)
- **Reverse Proxy Port:** `8787`

## Getting Started

Open http://localhost:8787 in your browser and complete the initial setup wizard:

1. **Choose your UI language**
2. **Add a download client** — select qBittorrent, enter its host/port/credentials
3. **Add an indexer** — or connect to Prowlarr for automatic indexer sync

Once the wizard finishes, you'll see an empty library. To populate it:

- Go to **Settings → Media Management** and add a **Root Folder** (e.g., `/books`) — this is where your organized book library will live
- Click **Add Author** and search by name — Readarr fetches metadata, covers, and available editions
- Optionally connect a **List** (Goodreads, etc.) to auto-import authors from your reading lists

### Download flow

qBittorrent downloads to its own directory → Readarr picks it up, renames the file, and moves it into `<Root Folder>/Author Name/Book Name/`

## Environment Variable Notes

| Variable | Description |
|---|---|
| `READARR_IMAGE` | Container image (default: `ghcr.io/hotio/readarr:release`) |
| `READARR_RESTART` | Restart policy (default: `unless-stopped`) |
| `READARR_PORT` | Published port for the web UI (default: `8787`) |
| `VOL_PATH` | Base path for persistent data volumes (default: `/data`) |
| `TZ` | Container timezone (default: `America/Vancouver`) |

## Volume Notes

| Volume | Purpose |
|---|---|
| `${VOL_PATH:-/data}/readarr/config` | Application configuration and database |
| `${VOL_PATH:-/data}/readarr/data` | Download client data and working directory |

## Network Notes

Requires an external `proxy` network. Create it once with:

```bash
docker network create proxy
```

## Docker Run

```bash
docker run -d \
  --name=readarr \
  -e PUID=1000 \
  -e PGID=1000 \
  -e UMASK=002 \
  -e TZ=America/Vancouver \
  -p 8787:8787 \
  -v ${VOL_PATH:-/data}/readarr/config:/config \
  -v ${VOL_PATH:-/data}/readarr/data:/data \
  --network proxy \
  --restart unless-stopped \
  ghcr.io/hotio/readarr:release
```

## Additional Notes / Gotchas

Nothing specific to this stack so far.

## Dockhand Stack, Deploy from Git

- **Cookbooks Repository**
- **stackname:** readarr_dev
- **Compose file path:** readarr_dev/compose.yaml
- **Additional env file (optional):** readarr_dev/sample.env

Load `readarr_dev/sample.env` into the Environment variables in Dockhand, then create the Stack.
