# Traefik

## Overview

Modern reverse proxy and load balancer designed for microservices and Docker environments.

## Project Details

-   **Project Repository:** [GitHub](https://github.com/traefik/traefik)
-   **Container Image:** [traefik](https://hub.docker.com/_/traefik)
-   **Documentation:** [doc.traefik.io](https://doc.traefik.io/traefik/)
-   **Reverse Proxy Port:** `8080` (dashboard)

## Getting Started

1. Start the container: `docker compose up -d`
2. Open http://localhost:8080 in your browser
3. Follow the initial setup wizard to configure the application

## Environment Variable Notes

    TRAEFIK_HTTP_PORT / TRAEFIK_HTTPS_PORT – entrypoint ports
    TRAEFIK_DASHBOARD_PORT – dashboard/API port

## Volume Notes

    /var/run/docker.sock – read-only Docker socket for service discovery
    /letsencrypt – ACME certificate storage

## Network Notes

Requires proxy network

## Docker Run

```bash
docker run -d \
  --name traefik \
  -p 80:80 -p 443:443 -p 8080:8080 \
  -v /var/run/docker.sock:/var/run/docker.sock:ro \
  traefik:v3 \
  --api.insecure=true --providers.docker=true \
  --providers.docker.exposedbydefault=false \
  --entrypoints.web.address=:80 --entrypoints.websecure.address=:443
```

## Additional Notes / Gotchas

This repo assumes Nginx Proxy Manager as the main reverse proxy — running Traefik alongside it will conflict on ports 80/443 unless you change them.
`--api.insecure=true` exposes the dashboard without auth; do not expose port 8080 publicly.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: traefik_dev
Compose file path: traefik_dev/compose.yaml
Additional env file (optional): traefik_dev/sample.env

Then "Load" traefik_dev/sample.env into the Environmental variables in dockhand

Create the Stack
