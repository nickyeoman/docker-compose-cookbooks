# Prowlarr

## Overview

Prowlarr is an indexer manager and proxy for the *arr ecosystem. It centralizes your torrent tracker and Usenet indexer configuration — add them once in Prowlarr and they sync automatically to Sonarr, Radarr, Lidarr, and Readarr. It's a modern replacement for Jackett with a unified API and built-in sync.

## Project Details

- **Project Repository:** [https://prowlarr.com/](https://prowlarr.com/)
- **Container Image:** [ghcr.io/hotio/prowlarr](https://hotio.dev/containers/prowlarr/)
- **Reverse Proxy Port:** `9696`

## Getting Started

Open http://localhost:9696 in your browser and complete the initial setup wizard:

1. **Choose your UI language**
2. **Add an indexer** — search or manually configure your preferred trackers/usenet providers
3. **Connect your *arr apps** — go to **Settings → Apps** and add Sonarr, Radarr, Lidarr, etc. Prowlarr will automatically sync all configured indexers to them
4. If you're migrating from Jackett, Prowlarr can import your existing indexer configs during setup

### Download flow

Prowlarr does not handle downloads. It only provides indexer search results to your *arr apps — they in turn send downloads to qBittorrent, SABnzbd, etc.

## Environment Variable Notes

| Variable | Description |
|---|---|
| `PROWLARR_IMAGE` | Container image (default: `ghcr.io/hotio/prowlarr:release`) |
| `PROWLARR_RESTART` | Restart policy (default: `unless-stopped`) |
| `PROWLARR_PORT` | Published port for the web UI (default: `9696`) |
| `VOL_PATH` | Base path for persistent data volumes (default: `/data`) |

## Volume Notes

| Volume | Purpose |
|---|---|
| `${VOL_PATH}/prowlarr/config` | Indexer configurations, app sync settings, database |

## Network Notes

Requires an external `proxy` network. Create it once with:

```bash
docker network create proxy
```

## Docker Run

```bash
docker run -d \
  --name=prowlarr \
  -e PUID=1000 \
  -e PGID=1000 \
  -e UMASK=002 \
  -p 9696:9696 \
  -v ${VOL_PATH:-/data}/prowlarr/config:/config \
  --network proxy \
  --restart unless-stopped \
  ghcr.io/hotio/prowlarr:release
```

## Dockhand Stack, Deploy from Git

- **Cookbooks Repository**
- **stackname:** prowlarr_dev
- **Compose file path:** prowlarr_dev/compose.yaml
- **Additional env file (optional):** prowlarr_dev/sample.env

Load `prowlarr_dev/sample.env` into the Environment variables in Dockhand, then create the Stack.
