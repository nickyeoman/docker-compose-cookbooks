# Bazarr

## Overview

Bazarr is a subtitle management companion for Sonarr and Radarr. It automatically downloads and synchronizes subtitles for your TV shows and movies from providers like OpenSubtitles, Podnapisi, and Subscene. Unlike the *arr media managers, Bazarr doesn't handle downloads or indexers — it focuses solely on keeping subtitles matched to your existing media library.

## Project Details

- **Project Repository:** [https://www.bazarr.media/](https://www.bazarr.media/)
- **Container Image:** [ghcr.io/hotio/bazarr](https://hotio.dev/containers/bazarr/)
- **Reverse Proxy Port:** `6767`

## Getting Started

Open http://localhost:6767 in your browser and complete the initial setup:

1. **Configure subtitle languages** — select your preferred languages (e.g., English, French)
2. **Connect Sonarr and Radarr** — go to **Settings → Sonarr** and **Settings → Radarr**, enter server URLs and API keys
3. **Add subtitle providers** — configure provider credentials (OpenSubtitles, etc.) in **Settings → Providers**
4. Bazarr will scan your existing media and begin downloading matching subtitles

### How it works

Bazarr monitors your Sonarr/Radarr libraries. When new media is added or existing media is detected without subtitles, it searches configured providers and downloads the best match. Subtitles are written directly alongside your video files in the `/media` volume.

## Environment Variable Notes

| Variable | Description |
|---|---|
| `BAZARR_IMAGE` | Container image (default: `ghcr.io/hotio/bazarr:release`) |
| `BAZARR_RESTART` | Restart policy (default: `unless-stopped`) |
| `BAZARR_PORT` | Published port for the web UI (default: `6767`) |
| `VOL_PATH` | Base path for persistent data volumes (default: `/data`) |
| `BAZARR_MEDIA` | Path to the shared media library (default: `/data/media`) — point this at the same library used by Sonarr, Radarr, and Jellyfin/etc. so subtitles land next to the video files |
| `TZ` | Container timezone (default: `America/Vancouver`) |

## Volume Notes

| Volume | Purpose |
|---|---|
| `${VOL_PATH:-/data}/bazarr/config` | Application configuration and database — holds `config/config.yaml` (Sonarr/Radarr connections, provider credentials, language profiles) and the SQLite database (`config/db/bazarr.db`) tracking subtitle history and sync state. Back this up before upgrades; losing it means reconfiguring providers and Sonarr/Radarr links from scratch. |
| `${BAZARR_MEDIA:-/data/media}` | Shared media library, kept separate from `VOL_PATH` since it's typically the same library mounted into Sonarr, Radarr, and Jellyfin/etc. — must include your TV and movie folders so Bazarr can write subtitles alongside video files |

## Network Notes

Requires an external `proxy` network. Create it once with:

```bash
docker network create proxy
```

## Docker Run

```bash
docker run -d \
  --name=bazarr \
  -e PUID=1000 \
  -e PGID=1000 \
  -e UMASK=002 \
  -e TZ=America/Vancouver \
  -p 6767:6767 \
  -v ${VOL_PATH:-/data}/bazarr/config:/config \
  -v ${BAZARR_MEDIA:-/data/media}:/media \
  --network proxy \
  --restart unless-stopped \
  ghcr.io/hotio/bazarr:release
```

## Additional Notes / Gotchas

Nothing specific to this stack so far.

## Dockhand Stack, Deploy from Git

- **Cookbooks Repository**
- **stackname:** bazarr_dev
- **Compose file path:** bazarr_dev/compose.yaml
- **Additional env file (optional):** bazarr_dev/sample.env

Load `bazarr_dev/sample.env` into the Environment variables in Dockhand, then create the Stack.
