# spotDL

## Overview

spotDL is a command-line music downloader that finds Spotify tracks on YouTube and downloads them with album art, lyrics, and metadata. This stack runs the optional web UI, providing a browser interface where you can paste Spotify links to download tracks, albums, or playlists.

## Project Details

- **Project Repository:** [https://github.com/spotDL/spotify-downloader](https://github.com/spotDL/spotify-downloader)
- **Container Image:** [spotdl/spotify-downloader](https://hub.docker.com/r/spotdl/spotify-downloader)
- **Web UI Port:** `8800`

## Getting Started

Open http://localhost:8800 in your browser:

1. Find a Spotify track, album, or playlist URL
2. Paste it into the spotDL web UI
3. Click download — spotDL finds the song on YouTube and saves it as an MP3 with full metadata

Downloaded files appear in the `/music` volume.

## Environment Variable Notes

| Variable | Description |
|---|---|
| `SPOTDL_IMAGE` | Container image (default: `spotdl/spotify-downloader:latest`) |
| `SPOTDL_RESTART` | Restart policy (default: `unless-stopped`) |
| `SPOTDL_PORT` | Published port for the web UI (default: `8800`) |
| `VOL_PATH` | Base path for persistent data volumes (default: `/data`) |

## Volume Notes

| Volume | Purpose |
|---|---|
| `${VOL_PATH:-/data}/spotdl/music` | Downloaded music files |

## Network Notes

Requires an external `proxy` network. Create it once with:

```bash
docker network create proxy
```

## Docker Run

```bash
docker run -d \
  --name=spotdl \
  -p 8800:8800 \
  -v ${VOL_PATH:-/data}/spotdl/music:/music \
  --network proxy \
  --restart unless-stopped \
  spotdl/spotify-downloader:latest \
  web
```

## Dockhand Stack, Deploy from Git

- **Cookbooks Repository**
- **stackname:** spotdl_dev
- **Compose file path:** spotdl_dev/compose.yaml
- **Additional env file (optional):** spotdl_dev/sample.env

Load `spotdl_dev/sample.env` into the Environment variables in Dockhand, then create the Stack.
