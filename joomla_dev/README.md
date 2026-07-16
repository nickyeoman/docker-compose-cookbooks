# Joomla

## Overview

Joomla is a self-hosted content management system (CMS) for building websites and web applications. This Docker Compose stack deploys Joomla with a MariaDB database, persistent storage, and an external reverse proxy.

## Project Details

-   **Project Repository:** [Joomla](https://www.joomla.org)
-   **Container Image:** [Docker Hub](https://hub.docker.com/_/joomla)
-   **Compose Example:** [Official Compose](https://hub.docker.com/_/joomla)
-   **Documentation:** [Joomla Docs](https://docs.joomla.org)
-   **Reverse Proxy Port:** `80`

## Getting Started

1. Copy `sample.env` to `.env` and edit the values (especially passwords)
2. Start the stack: `docker compose up -d`
3. Open http://localhost:8080 (or your proxy domain) in your browser
4. If `JOOMLA_ADMIN_*` env vars are set, the installer is skipped and an admin user is created automatically. Otherwise, follow the web setup wizard.

## Environment Variable Notes

### Compose
-   `VOL_PATH` – base path for persistent data volumes (default: `/data`)
-   `JOOMLA_PORT` – host port for Joomla (default: `8080`)
-   `JOOMLA_IMAGE` – Joomla image tag (default: `joomla:5`)
-   `JOOMLA_RESTART` – container restart policy (default: `unless-stopped`)

### Database
-   `MARIADB_IMAGE` – MariaDB image tag (default: `mariadb:10.11`)
-   `MARIADB_ROOT_PASSWORD` – MariaDB root password (required)
-   `JOOMLA_DB_NAME` – database name (default: `joomla`)
-   `JOOMLA_DB_USER` – database user (default: `joomla`)
-   `JOOMLA_DB_PASSWORD` – database user password (required)

### Joomla Auto-Deployment
-   `JOOMLA_SITE_NAME` – site name displayed in Joomla
-   `JOOMLA_ADMIN_USER` – full name of the admin user
-   `JOOMLA_ADMIN_USERNAME` – admin login username (default: `admin`)
-   `JOOMLA_ADMIN_PASSWORD` – admin password (required, min 12 chars)
-   `JOOMLA_ADMIN_EMAIL` – admin email address

## Volume Notes

-   `${VOL_PATH:-/data}/joomla/db` – MariaDB data files
-   `${VOL_PATH:-/data}/joomla/html` – Joomla web root (uploaded files, extensions, custom templates)

## Network Notes

Requires the external `proxy` network for reverse proxy access.

## Docker Run

```bash
docker run -d \
  --name joomla-mariadb \
  -e MARIADB_DATABASE=joomla \
  -e MARIADB_USER=joomla \
  -e MARIADB_PASSWORD=ChangeThisPassword \
  -e MARIADB_ROOT_PASSWORD=ChangeThisRootPassword \
  -v /data/joomla/db:/var/lib/mysql \
  mariadb:10.11
```

```bash
docker run -d \
  --name joomla \
  -p 8080:80 \
  -e JOOMLA_DB_HOST=mariadb \
  -e JOOMLA_DB_USER=joomla \
  -e JOOMLA_DB_PASSWORD=ChangeThisPassword \
  -e JOOMLA_DB_NAME=joomla \
  -e JOOMLA_SITE_NAME="My Joomla Site" \
  -e JOOMLA_ADMIN_USER="Joomla Admin" \
  -e JOOMLA_ADMIN_USERNAME=admin \
  -e JOOMLA_ADMIN_PASSWORD=ChangeThisPassword \
  -e JOOMLA_ADMIN_EMAIL=admin@example.com \
  -v /data/joomla/html:/var/www/html \
  --link joomla-mariadb:mariadb \
  joomla:5
```

## Additional Notes / Gotchas

-   Setting `JOOMLA_ADMIN_*` env vars enables auto-deployment and skips the browser setup wizard. Remove them to run the wizard manually.
-   Admin password must be at least 12 characters long.
-   The `html` volume persists uploaded files and installed extensions. Back it up before major Joomla upgrades.
-   For SMTP configuration, add `JOOMLA_SMTP_HOST` and `JOOMLA_SMTP_HOST_PORT` environment variables.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: joomla
Compose file path: joomla_dev/compose.yaml
Additional env file (optional): joomla_dev/sample.env

Then "Load" joomla_dev/sample.env into the Environmental variables in dockhand

Create the Stack
