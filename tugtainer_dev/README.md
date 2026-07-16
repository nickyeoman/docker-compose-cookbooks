# Tugtainer

## Overview

Web UI alternative to Watchtower for checking and automating Docker container image updates.

## Project Details

-   **Project Repository:** [GitHub](https://github.com/Quenary/tugtainer)
-   **Container Image:** [ghcr.io/quenary/tugtainer](https://github.com/Quenary/tugtainer/pkgs/container/tugtainer)
-   **Documentation:** [GitHub README](https://github.com/Quenary/tugtainer)
-   **Reverse Proxy Port:** `80`

## Getting Started

1. Start the container: `docker compose up -d`
2. Open http://localhost:9412 in your browser
3. Follow the initial setup wizard to configure the application

## Environment Variable Notes

    TUGTAINER_PORT – host port for the web UI

## Volume Notes

    /tugtainer – application data
    /var/run/docker.sock – read-only Docker socket (required)

## Network Notes

Requires proxy network

## Docker Run

```bash
docker run -d \
  --name tugtainer \
  -p 9412:80 \
  -v /data/tugtainer:/tugtainer \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  ghcr.io/quenary/tugtainer:1
```

## Additional Notes / Gotchas

Upstream states the project is not production-ready — home lab use only.
It is dependency-aware and can update compose stacks in the right order.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: tugtainer_dev
Compose file path: tugtainer_dev/compose.yaml
Additional env file (optional): tugtainer_dev/sample.env

Then "Load" tugtainer_dev/sample.env into the Environmental variables in dockhand

Create the Stack
