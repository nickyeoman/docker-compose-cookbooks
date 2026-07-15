# Matomo Web Analytics

## Overview

Matomo is an open-source web analytics platform. This stack runs Matomo with a MariaDB database.

## Project Details

-   **Project Repository:** [https://github.com/matomo-org/matomo](https://github.com/matomo-org/matomo)
-   **Container Image:** [Docker Hub](https://hub.docker.com/_/matomo)
-   **Documentation:** [https://matomo.org/docs](https://matomo.org/docs)
-   **Reverse Proxy Port:** `80`

## Getting Started

1. Start the stack: `docker compose up -d`
2. Open http://localhost:${MATOMO_PORT:-8080} in your browser
3. Follow the web setup wizard, using database host `matomo-db`

## Environment Variable Notes

    VOL_PATH – base path for persistent data volumes
    VOL_PROJECTS – base path for project directories
    MATOMO_IMAGE – Matomo container image (default: matomo:latest)
    MATOMO_RESTART – restart policy (default: unless-stopped)
    MATOMO_PORT – host port mapped to container port 80 (default: 8080)
    MATOMO_DB_IMAGE – MariaDB container image (default: mariadb:10.4)
    MATOMO_MYSQL_ROOT_PASSWORD – MariaDB root password
    MATOMO_MYSQL_PASSWORD – MariaDB matomo user password
    MATOMO_DB_PASSWORD – Matomo's database password (must match MATOMO_MYSQL_PASSWORD)

## Volume Notes

    ${VOL_PATH}/matomo_dev/db – MariaDB data directory
    ${VOL_PATH}/matomo_dev/html – Matomo application files
    ${VOL_PATH}/matomo_dev/config – Matomo configuration
    ${VOL_PATH}/matomo_dev/logs – Matomo log files

## Network Notes

Requires the external `proxy` network (Nginx Proxy Manager). An internal bridge network `internal` is created for inter-service communication.

## Docker Run

```bash
docker run -d \
  --name matomo \
  -v ${VOL_PATH:-/data}/matomo_dev/html:/var/www/html \
  -v ${VOL_PATH:-/data}/matomo_dev/config:/var/www/html/config \
  -v ${VOL_PATH:-/data}/matomo_dev/logs:/var/www/html/logs \
  -e MATOMO_DB_HOST=matomo-db \
  -e MATOMO_DB_USER=matomo \
  -e MATOMO_DB_PASSWORD=changeme \
  -e MATOMO_DB_NAME=matomo \
  -p 8080:80 \
  --network proxy \
  matomo:latest
```

## Additional Notes / Gotchas

- On first run, Matomo will guide you through the setup wizard. Use `matomo-db` as the database host.
- The `MATOMO_DB_PASSWORD` env var must match the `MYSQL_PASSWORD` set for the MariaDB matomo user.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: MATOMO_DEV
Compose file path: matomo_dev/compose.yaml
Additional env file (optional): matomo_dev/sample.env

Then "Load" matomo_dev/sample.env into the Environmental variables in dockhand

Create the Stack
