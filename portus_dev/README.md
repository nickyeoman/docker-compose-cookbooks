# Portus

## Overview

Web UI and authorization service for on-premise Docker registries.

## Project Details

-   **Project Repository:** [GitHub](https://github.com/SUSE/Portus)
-   **Container Image:** [opensuse/portus](https://hub.docker.com/r/opensuse/portus/)
-   **Documentation:** [port.us.org](http://port.us.org/)
-   **Reverse Proxy Port:** `3000`

## Getting Started

1. Start the container: `docker compose up -d`
2. Open http://localhost:3000 in your browser
3. Follow the initial setup wizard to configure the application

## Environment Variable Notes

    PORTUS_FQDN – hostname Portus is reached at (must match registry config)
    PORTUS_SECRET_KEY_BASE – generate with `openssl rand -hex 64`
    PORTUS_PASSWORD – internal password Portus uses to talk to the registry

## Volume Notes

    /var/lib/mysql – MariaDB data

## Network Notes

Requires proxy network

## Docker Run

```bash
docker run -d \
  --name portus \
  -p 3000:3000 \
  -e PORTUS_MACHINE_FQDN_VALUE=portus.localhost \
  -e PORTUS_SECRET_KEY_BASE=changeme \
  -e PORTUS_PASSWORD=changeme \
  -e PORTUS_DB_HOST=dbhost \
  opensuse/portus:2.5
```

## Additional Notes / Gotchas

Portus was abandoned by openSUSE/SUSE years ago — kept here for reference only. It also needs a Docker registry container configured with Portus as its token auth endpoint (not included). For a maintained registry UI consider Harbor or the built-in gitea registry.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: portus_dev
Compose file path: portus_dev/compose.yaml
Additional env file (optional): portus_dev/sample.env

Then "Load" portus_dev/sample.env into the Environmental variables in dockhand

Create the Stack
