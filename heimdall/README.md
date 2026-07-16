# Heimdall

## Overview

Heimdall is a lightweight web-based dashboard for organizing and launching your self-hosted applications.

## Project Details

-   **Project Repository:** [Offical Website](https://heimdall.site/)
-   **Container Image:** [Docker Hub](https://hub.docker.com/r/linuxserver/heimdall)
-   **Reverse Proxy Port:** `80`

## Getting Started

1. Start the container: `docker compose up -d`
2. Open http://localhost:8000 in your browser
3. Follow the initial setup wizard to configure the application

## Environment Variable Notes

FORCE_HTTPS=true - For https

## Volume Notes

    /config – host path /data/heimdall

## Network Notes

Requires proxy network

## Docker Run

```bash
docker run -d \
  --name heimdall \
  -p 8000:80 \
  -v /data/heimdall:/config \
  linuxserver/heimdall:latest
```

See compose.yaml for the full set of environment variables.

## Additional Notes / Gotchas

Still working on the staging config, TODO: where is domain base path set?

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: heimdall
Compose file path: heimdall/compose.yaml
Additional env file (optional): heimdall/sample.env

Then "Load" heimdall/sample.env into the Environmental variables in dockhand

Create the Stack
