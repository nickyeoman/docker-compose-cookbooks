# MeTube

## Overview

MeTube is a self-hosted web UI for yt-dlp. Paste a video or playlist URL from YouTube (or any of the hundreds of sites yt-dlp supports) and it downloads the media to the server.

## Project Details

- **Project Repository:** [https://github.com/alexta69/metube](https://github.com/alexta69/metube)
- **Container Image:** [ghcr.io/alexta69/metube](https://github.com/alexta69/metube/pkgs/container/metube)
- **Documentation:** [README](https://github.com/alexta69/metube#readme)
- **Reverse Proxy Port:** `8081`

## Getting Started

1. Start the container: `docker compose up -d`
2. Open http://localhost:8081 in your browser
3. Paste a URL, pick a quality/format, and click **Add**. Finished files land in the downloads volume.

## Environment Variable Notes

| Variable | Description |
|---|---|
| `METUBE_IMAGE` | Container image (default: `ghcr.io/alexta69/metube:latest`) |
| `METUBE_CONTAINER_NAME` | Container name shown in Dockhand / `docker ps` (default: `metube`) |
| `METUBE_RESTART` | Restart policy (default: `unless-stopped`) |
| `METUBE_PORT` | Published port for the web UI (default: `8081`) |
| `METUBE_YTDL_OPTIONS` | yt-dlp options applied to **every** download, as one-line JSON (default: blank = MeTube's default `{}`) |
| `METUBE_YTDL_OPTIONS_PRESETS` | Named yt-dlp option bundles, picked per download under **Advanced Options** in the UI, as one-line JSON. Ships with a `Video + FLAC` preset |
| `METUBE_AUDIO_DOWNLOAD_DIR` | Container path for audio-only downloads (default: `/downloads/audio`, i.e. `/data/media/downloads/metube/audio` on the host). Keep it under `/downloads` so it stays on the shared media disk |
| `METUBE_MEDIA` | Shared media root on the host (default: `/data`, so files land in `/data/media/downloads/metube`). Must be the same root Lidarr, Jellyfin, etc. use |

`UID`/`GID`/`UMASK` are fixed at `1000`/`1000`/`002` (same as the other media apps) in the compose file so downloaded files are owned by your normal user. Many more options (`DARK_MODE`, `YTDL_OPTIONS`, `OUTPUT_TEMPLATE`, `DEFAULT_THEME`, …) are listed in the upstream README.

## Volume Notes

| Volume | Purpose |
|---|---|
| `${METUBE_MEDIA:-/data}/media/downloads/metube` → `/downloads` | Downloaded files and the queue/history state (`.metube` folder). Lives in the shared media downloads folder so Lidarr can see it as `/media/downloads/metube` |

## Network Notes

Requires an external `proxy` network. Create it once with:

```bash
docker network create proxy
```

## Docker Run

```bash
docker run -d \
  --name=metube \
  -e UID=1000 \
  -e GID=1000 \
  -e UMASK=002 \
  -e AUDIO_DOWNLOAD_DIR=/downloads/audio \
  -p 8081:8081 \
  -v ${METUBE_MEDIA:-/data}/media/downloads/metube:/downloads \
  --network proxy \
  --restart unless-stopped \
  ghcr.io/alexta69/metube:latest
```

## Additional Notes / Gotchas

- **Importing music into Lidarr.** MeTube writes to `/data/media/downloads/metube`, which Lidarr sees as `/media/downloads/metube`. Audio-only downloads go to the `audio` subfolder. In Lidarr go to **Wanted → Manual Import**, pick `/media/downloads/metube/audio` (or the parent folder for audio extracted by the `Video + FLAC` preset), match the tracks to an artist/album and import. Because both folders are on the same `/data/media` filesystem, Lidarr hardlinks the files (enable **Settings → Media Management → Use Hardlinks instead of Copy**) instead of copying them.
- **Video and FLAC in one download.** Pick a video format, open **Advanced Options** and choose the `Video + FLAC` preset. yt-dlp keeps the video (`keepvideo`) and also extracts a FLAC next to it. To do this for every download instead, move the JSON from `METUBE_YTDL_OPTIONS_PRESETS` into `METUBE_YTDL_OPTIONS` (without the preset name wrapper). Don't use it with an audio-only format: MeTube already extracts audio there. With `keepvideo`, yt-dlp may also leave the separate video/audio stream files (`*.f137.mp4`, `*.f251.webm`) beside the merged file.
- **Don't point MeTube straight at `/media/music`.** Lidarr only recognizes files inside its `Artist/Album/` layout, so loose MeTube files there show up as unmapped instead of being imported.
- Create the folder as user 1000 first (`sudo mkdir -p /data/media/downloads/metube && sudo chown -R 1000:1000 /data/media/downloads/metube`). MeTube runs as UID/GID 1000 to match the other media apps.
- MeTube has no built-in authentication — put it behind an auth layer (NPM access list, Authelia, etc.) if exposed publicly.
- yt-dlp breaks periodically when sites change; pull the latest image to get fixes.

## Dockhand Stack, Deploy from Git

- **Cookbooks Repository**
- **stackname:** metube
- **Compose file path:** metube/compose.yaml
- **Additional env file (optional):** metube/sample.env

Load `metube/sample.env` into the Environment variables in Dockhand, then create the Stack.

Or create it from the CLI with the defaults preloaded (edit the variables in Dockhand, then deploy):

```bash
DOCKHAND_URL=https://dockhand.example.com DOCKHAND_TOKEN=dh_xxx ./dockhand-stack_dev.bash metube
```
