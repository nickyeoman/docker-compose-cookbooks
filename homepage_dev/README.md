# homepage

Last Updated: Thu August 15, 2024 16:11:59 PDT

## Overview

Project: https://gethomepage.dev/latest/
Docker Compose Example: https://gethomepage.dev/latest/installation/docker/
Proxy Port: 3000


If you want to use the optional docker socket, you must run as root.

## Project Details

-   **Container Image:** [ghcr.io/gethomepage/homepage:latest](https://github.com/gethomepage/homepage)
-   **Reverse Proxy Port:** `3000`

## Getting Started

1. Start the container: `docker compose up -d`
2. Open http://localhost:3000 in your browser
3. Follow the initial setup wizard to configure the application

## Environment Variable Notes

    HOMEPAGE_PORT – default: 3000

## Volume Notes

    /app/config – host path /data/homepage/config

## Network Notes

Requires proxy network

## Docker Run

```bash
docker run -d \
  --name homepage \
  -p 3000:3000 \
  -v /data/homepage/config:/app/config \
  ghcr.io/gethomepage/homepage:latest
```

See compose.yaml for the full set of environment variables.

## Additional Notes / Gotchas

Nothing specific to this stack so far.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: homepage_dev
Compose file path: homepage_dev/compose.yaml
Additional env file (optional): homepage_dev/sample.env

Then "Load" homepage_dev/sample.env into the Environmental variables in dockhand

Create the Stack
