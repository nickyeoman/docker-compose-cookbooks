# Jellyseerr

## Overview

Jellyseerr is a free and open-source request management system for your Jellyfin/Emby media library, forked from Overseerr. It lets users browse, discover, and request movies and TV shows. Approved requests are sent to Sonarr/Radarr for automatic downloading.

## Project Details

- **Project Repository:** [https://docs.jellyseerr.dev/](https://docs.jellyseerr.dev/)
- **Container Image:** [ghcr.io/hotio/jellyseerr](https://hotio.dev/containers/jellyseerr/)
- **Reverse Proxy Port:** `5055`

## Getting Started

Open http://localhost:5055 in your browser and complete the initial setup:

1. **Create your admin account**
2. **Connect your media server** — select Jellyfin or Emby, enter server URL and API key
3. **Connect Sonarr and Radarr** — Jellyseerr needs these to handle requests
4. Users can now browse your library and submit requests via the Jellyseerr UI

### Request flow

User submits a request → approved (auto or manual) → Jellyseerr sends it to Sonarr/Radarr → download client grabs it → media appears in Jellyfin

## Environment Variable Notes

| Variable | Description |
|---|---|
| `JELLYSEERR_IMAGE` | Container image (default: `ghcr.io/hotio/jellyseerr:release`) |
| `JELLYSEERR_RESTART` | Restart policy (default: `unless-stopped`) |
| `JELLYSEERR_PORT` | Published port for the web UI (default: `5055`) |
| `VOL_PATH` | Base path for persistent data volumes (default: `/data`) |

## Volume Notes

| Volume | Purpose |
|---|---|
| `${VOL_PATH:-/data}/jellyseerr/config` | Application configuration and database |

## Network Notes

Requires an external `proxy` network. Create it once with:

```bash
docker network create proxy
```

## Docker Run

```bash
docker run -d \
  --name=jellyseerr \
  -e PUID=1000 \
  -e PGID=1000 \
  -e UMASK=002 \
  -p 5055:5055 \
  -v ${VOL_PATH:-/data}/jellyseerr/config:/config \
  --network proxy \
  --restart unless-stopped \
  ghcr.io/hotio/jellyseerr:release
```

## Additional Notes / Gotchas

Nothing specific to this stack so far.

## Dockhand Stack, Deploy from Git

- **Cookbooks Repository**
- **stackname:** jellyseerr_dev
- **Compose file path:** jellyseerr_dev/compose.yaml
- **Additional env file (optional):** jellyseerr_dev/sample.env

Load `jellyseerr_dev/sample.env` into the Environment variables in Dockhand, then create the Stack.
