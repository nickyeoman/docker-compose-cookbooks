# Jellyfin

## Overview

* [DockerHub jellyfin](https://hub.docker.com/r/jellyfin/jellyfin)
* [Docs](https://jellyfin.org/docs/)

### Ports

* 8096/tcp is used by default for HTTP traffic. You can change this in the dashboard.
* 8920/tcp is used by default for HTTPS traffic. You can change this in the dashboard.
* 1900/udp is used for service auto-discovery. This is not configurable.
* 7359/udp is also used for auto-discovery. This is not configurable.

## Project Details

-   **Container Image:** [jellyfin/jellyfin:latest](https://hub.docker.com/r/jellyfin/jellyfin)
-   **Reverse Proxy Port:** `8096`

## Getting Started

1. Start the container: `docker compose up -d`
2. Open http://localhost:8096 in your browser
3. Follow the initial setup wizard to configure the application

## Environment Variable Notes

    JELLYFIN_URL – default: http://localhost:8096
    JELLYFIN_PORT – default: 8096

## Volume Notes

    /cache – host path /data/jellyfin/cache
    /config – host path /data/jellyfin/config
    /books – host path /data/jellyfin/media/books
    /movies – host path /data/jellyfin/media/movies
    /music – host path /data/jellyfin/media/music
    /photos – host path /data/jellyfin/media/photos
    /shows – host path /data/jellyfin/media/shows

## Network Notes

Requires proxy network

## Docker Run

```bash
docker run -d \
  --name jellyfin \
  -p 8096:8096 \
  -v /data/jellyfin/cache:/cache \
  -v /data/jellyfin/config:/config \
  -v /data/jellyfin/media/books:/books \
  -v /data/jellyfin/media/movies:/movies \
  -v /data/jellyfin/media/music:/music \
  jellyfin/jellyfin:latest
```

See compose.yaml for the full set of environment variables.

## Additional Notes / Gotchas

Nothing specific to this stack so far.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: jellyfin_dev
Compose file path: jellyfin_dev/compose.yaml
Additional env file (optional): jellyfin_dev/sample.env

Then "Load" jellyfin_dev/sample.env into the Environmental variables in dockhand

Create the Stack
