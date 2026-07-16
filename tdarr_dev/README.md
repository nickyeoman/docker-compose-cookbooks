# Tdarr

## Overview

Distributed media transcoding and library automation (part of the *rr media stack).

## Project Details

-   **Project Repository:** [GitHub](https://github.com/HaveAGitGat/Tdarr)
-   **Container Image:** [ghcr.io/haveagitgat/tdarr](https://github.com/HaveAGitGat/Tdarr/pkgs/container/tdarr)
-   **Documentation:** [Docs](https://docs.tdarr.io/)
-   **Reverse Proxy Port:** `8265`

## Getting Started

1. Start the container: `docker compose up -d`
2. Open http://localhost:8265 in your browser
3. Follow the initial setup wizard to configure the application

## Environment Variable Notes

    TDARR_MEDIA – host path to your media library
    TDARR_SERVER_PORT – internal server port used by nodes (8266)
    TDARR_NODE_NAME – name of the built-in internal node

## Volume Notes

    /app/server – Tdarr server data
    /app/configs – configuration
    /app/logs – logs
    /temp – transcode cache (use fast storage)
    /media – your media library

## Network Notes

Requires proxy network

## Docker Run

```bash
docker run -d \
  --name tdarr \
  -p 8265:8265 -p 8266:8266 \
  -e TZ=America/Vancouver \
  -e serverIP=0.0.0.0 -e serverPort=8266 -e webUIPort=8265 \
  -e internalNode=true -e inContainer=true \
  -v /data/tdarr/server:/app/server \
  -v /data/tdarr/configs:/app/configs \
  -v /data/media:/media \
  ghcr.io/haveagitgat/tdarr:latest
```

## Additional Notes / Gotchas

For hardware transcoding pass through your GPU (e.g. `--gpus all` or `/dev/dri`); not included in this compose file.
Extra transcode nodes can join by pointing at port 8266.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: tdarr_dev
Compose file path: tdarr_dev/compose.yaml
Additional env file (optional): tdarr_dev/sample.env

Then "Load" tdarr_dev/sample.env into the Environmental variables in dockhand

Create the Stack
