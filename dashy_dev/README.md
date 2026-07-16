# Dashy

## Overview

Customizable self-hosted dashboard for organizing apps, services, and links.

## Project Details

-   **Project Repository:** [GitHub](https://github.com/Lissy93/dashy)
-   **Container Image:** [lissy93/dashy](https://hub.docker.com/r/lissy93/dashy)
-   **Documentation:** [dashy.to](https://dashy.to/docs/)
-   **Reverse Proxy Port:** `8080`

## Getting Started

1. Start the container: `docker compose up -d`
2. Open http://localhost:4000 in your browser
3. Follow the initial setup wizard to configure the application

## Environment Variable Notes

    DASHY_PORT – host port for the web UI

## Volume Notes

    /app/user-data – conf.yml and all dashboard configuration

## Network Notes

Requires proxy network

## Docker Run

```bash
docker run -d \
  --name dashy \
  -p 4000:8080 \
  -v /data/dashy/user-data:/app/user-data \
  lissy93/dashy:latest
```

## Additional Notes / Gotchas

Configuration lives in `user-data/conf.yml` and can also be edited from the UI.
The repo already contains heimdall and homepage_dev as alternative dashboards.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: dashy_dev
Compose file path: dashy_dev/compose.yaml
Additional env file (optional): dashy_dev/sample.env

Then "Load" dashy_dev/sample.env into the Environmental variables in dockhand

Create the Stack
