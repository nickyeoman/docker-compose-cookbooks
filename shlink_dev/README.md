# Shlink

## Overview

Shlink is a self-hosted URL shortener with a REST API and web client for managing short links, tracking visits, and generating QR codes. This Docker Compose stack deploys Shlink with MariaDB, the web client, and an external reverse proxy.

## Project Details

-   **Project Repository:** [Shlink](https://shlink.io)
-   **Container Image:** [Docker Hub](https://hub.docker.com/r/shlinkio/shlink)
-   **Compose Example:** [Official Docs](https://shlink.io/documentation/install-docker/)
-   **Documentation:** [Docs](https://shlink.io/documentation)
-   **Reverse Proxy Port:** `8080` (Shlink API), `8003` (web client)

## Getting Started

1. Copy `sample.env` to `.env` and edit all values (especially `SHLINK_DOMAIN`, database passwords)
2. Start the stack: `docker compose up -d`
3. Access the Shlink REST API at http://localhost:8080
4. Access the web client at http://localhost:8003
5. Configure the web client with your Shlink server URL and API key (generate one via the CLI)

## Environment Variable Notes

### Compose
-   `VOL_PATH` – base path for persistent data (default: `/data`)
-   `SHLINK_IMAGE` – Shlink image tag (default: `shlinkio/shlink:latest`)
-   `SHLINK_WEB_CLIENT_IMAGE` – web client image tag (default: `shlinkio/shlink-web-client:latest`)
-   `SHLINK_RESTART` – restart policy (default: `unless-stopped`)
-   `SHLINK_PORT` – Shlink API host port (default: `8080`)
-   `SHLINK_WEB_CLIENT_PORT` – web client host port (default: `8003`)

### Database
-   `MARIADB_IMAGE` – MariaDB image tag (default: `mariadb:10.11`)
-   `MARIADB_ROOT_PASSWORD` – MariaDB root password (required)
-   `SHLINK_DB_NAME` – database name (default: `shlink`)
-   `SHLINK_DB_USER` – database user (default: `shlink`)
-   `SHLINK_DB_PASSWORD` – database password (required)

### Shlink
-   `SHLINK_DOMAIN` – default short domain (default: `localhost`)
-   `SHLINK_HTTPS` – whether HTTPS is enabled (default: `false`)
-   `SHLINK_REDIRECT_URL` – base URL redirect for unknown short codes (default: `https://localhost`)
-   `TZ` – timezone (default: `America/Vancouver`)

## Volume Notes

-   `${VOL_PATH:-/data}/shlink/db` – MariaDB data files
-   `${VOL_PATH:-/data}/shlink/web-client` – web client static config (servers.json)

## Network Notes

Requires the external `proxy` network for reverse proxy access.

## Docker Run

```bash
docker run -d \
  --name shlink-mariadb \
  -e MARIADB_DATABASE=shlink \
  -e MARIADB_USER=shlink \
  -e MARIADB_PASSWORD=ChangeThisPassword \
  -e MARIADB_ROOT_PASSWORD=ChangeThisRootPassword \
  -v /data/shlink/db:/var/lib/mysql \
  mariadb:10.11
```

```bash
docker run -d \
  --name shlink \
  -p 8080:8080 \
  -e DEFAULT_DOMAIN=localhost \
  -e IS_HTTPS_ENABLED=false \
  -e DB_DRIVER=maria \
  -e DB_HOST=mariadb \
  -e DB_NAME=shlink \
  -e DB_USER=shlink \
  -e DB_PASSWORD=ChangeThisPassword \
  -e DEFAULT_BASE_URL_REDIRECT=https://localhost \
  shlinkio/shlink:latest
```

```bash
docker run -d \
  --name shlink-web-client \
  -p 8003:80 \
  -v /data/shlink/web-client:/usr/share/nginx/html \
  shlinkio/shlink-web-client:latest
```

## Additional Notes / Gotchas

-   The web client does **not** have built-in user authentication. Use Nginx Proxy Manager (or similar) to add basic auth or IP restrictions in front of it.
-   Generate an API key after starting: `docker compose exec shlink shlink api-key:generate`
-   Use the API key to configure the web client under "Settings > Manage Servers".
-   After changing `SHLINK_DOMAIN`, you must update the domain in Shlink's config or via the API.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: shlink
Compose file path: shlink_dev/compose.yaml
Additional env file (optional): shlink_dev/sample.env

Then "Load" shlink_dev/sample.env into the Environmental variables in dockhand

Create the Stack
