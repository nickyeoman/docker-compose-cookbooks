# Sencho

## Overview

Self-hosted, multi-node Docker Compose management dashboard.

## Project Details

-   **Project Repository:** [GitHub](https://github.com/Studio-Saelix/sencho)
-   **Container Image:** [saelix/sencho](https://hub.docker.com/r/saelix/sencho)
-   **Documentation:** [docs.sencho.io](https://docs.sencho.io/)
-   **Reverse Proxy Port:** `1852`

## Getting Started

1. Start the container: `docker compose up -d`
2. Open http://localhost:1852 in your browser
3. Follow the initial setup wizard to configure the application

## Environment Variable Notes

    SENCHO_COMPOSE_DIR – host directory where compose stacks live (source of truth)

## Volume Notes

    /data – Sencho application data
    /compose – your compose stacks on the host filesystem
    /var/run/docker.sock – Docker socket (required)

## Network Notes

Requires proxy network

## Docker Run

```bash
docker run -d \
  --name sencho \
  -p 1852:1852 \
  -e COMPOSE_DIR=/compose -e DATA_DIR=/data \
  -v /data/sencho/data:/data \
  -v /data/compose:/compose \
  -v /var/run/docker.sock:/var/run/docker.sock \
  saelix/sencho:latest
```

## Additional Notes / Gotchas

Sencho overlaps heavily with Dockhand (the manager this repo is built around) — treat this stack as an evaluation/experiment, not a replacement.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: sencho_dev
Compose file path: sencho_dev/compose.yaml
Additional env file (optional): sencho_dev/sample.env

Then "Load" sencho_dev/sample.env into the Environmental variables in dockhand

Create the Stack
