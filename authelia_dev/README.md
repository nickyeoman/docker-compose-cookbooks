# Authelia

## Overview

Single sign-on and 2FA portal for protecting apps behind a reverse proxy (lighter replacement for Authentik).

## Project Details

-   **Project Repository:** [GitHub](https://github.com/authelia/authelia)
-   **Container Image:** [authelia/authelia](https://hub.docker.com/r/authelia/authelia)
-   **Documentation:** [authelia.com](https://www.authelia.com/)
-   **Reverse Proxy Port:** `9091`

## Getting Started

1. Start the container: `docker compose up -d`
2. Open http://localhost:9091 in your browser
3. Follow the initial setup wizard to configure the application

## Environment Variable Notes

    Configuration is file-based; env vars can override any setting using the AUTHELIA_ prefix

## Volume Notes

    /config – configuration.yml, users_database.yml, and the local SQLite storage

## Network Notes

Requires proxy network

## Docker Run

```bash
docker run -d \
  --name authelia \
  -p 9091:9091 \
  -e TZ=America/Vancouver \
  -v /data/authelia/config:/config \
  authelia/authelia:latest
```

## Additional Notes / Gotchas

Authelia will not start without a valid `configuration.yml` in the config volume — generate one from the docs first (session secret, storage encryption key, and a users_database.yml are the minimum).
Works as forward-auth with Nginx Proxy Manager.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: authelia_dev
Compose file path: authelia_dev/compose.yaml
Additional env file (optional): authelia_dev/sample.env

Then "Load" authelia_dev/sample.env into the Environmental variables in dockhand

Create the Stack
