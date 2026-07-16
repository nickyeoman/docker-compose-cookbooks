# Picard

## Overview

MusicBrainz-powered music file tagging and organization tool, accessed through a web-based desktop.

## Project Details

-   **Project Repository:** [GitHub](https://github.com/mikenye/docker-picard)
-   **Container Image:** [mikenye/picard](https://hub.docker.com/r/mikenye/picard)
-   **Documentation:** [picard.musicbrainz.org](https://picard.musicbrainz.org/)
-   **Reverse Proxy Port:** `5800`

## Getting Started

1. Start the container: `docker compose up -d`
2. Open http://localhost:5800 in your browser
3. Follow the initial setup wizard to configure the application

## Environment Variable Notes

    PICARD_MUSIC – host path to your music library
    PICARD_PUID / PICARD_PGID – ownership for written tags/files

## Volume Notes

    /config – Picard settings
    /storage – your music library

## Network Notes

Requires proxy network

## Docker Run

```bash
docker run -d \
  --name picard \
  -p 5800:5800 \
  -e TZ=America/Vancouver \
  -v /data/picard/config:/config:rw \
  -v /data/media/music:/storage:rw \
  mikenye/picard:latest
```

## Additional Notes / Gotchas

This is a GUI app streamed to the browser via VNC — it is single-user and unauthenticated by default; keep it behind the proxy.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: picard_dev
Compose file path: picard_dev/compose.yaml
Additional env file (optional): picard_dev/sample.env

Then "Load" picard_dev/sample.env into the Environmental variables in dockhand

Create the Stack
