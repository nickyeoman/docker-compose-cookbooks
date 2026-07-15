# Monica Personal CRM

## Overview

Monica is an open-source personal relationship manager. This stack runs Monica with a MariaDB database.

## Project Details

-   **Project Repository:** [https://github.com/monicahq/monica](https://github.com/monicahq/monica)
-   **Container Image:** [Docker Hub](https://hub.docker.com/_/monica)
-   **Documentation:** [https://www.monicahq.com/](https://www.monicahq.com/)
-   **Reverse Proxy Port:** `80`

## Getting Started

1. Start the stack: `docker compose up -d`
2. Open http://localhost:${MONICA_PORT:-8081} in your browser
3. Follow the setup wizard

## Environment Variable Notes

    VOL_PATH – base path for persistent data volumes
    VOL_PROJECTS – base path for project directories
    MONICA_IMAGE – Monica container image (default: monica:latest)
    MONICA_RESTART – restart policy (default: unless-stopped)
    MONICA_PORT – host port mapped to container port 80 (default: 8081)
    MONICA_APP_ENV – application environment (default: production)
    MONICA_DB_IMAGE – MariaDB container image (default: mariadb:11)
    MONICA_DB_PASSWORD – Monica database password
    MONICA_MYSQL_ROOT_PASSWORD – MariaDB root password

## Volume Notes

    ${VOL_PATH}/monica_dev/db – MariaDB data directory
    ${VOL_PATH}/monica_dev/storage – Monica storage (avatars, exports, etc.)

## Network Notes

Requires the external `proxy` network (Nginx Proxy Manager). An internal bridge network `internal` is created for inter-service communication.

## Docker Run

```bash
docker run -d \
  --name monica \
  -v ${VOL_PATH:-/data}/monica_dev/storage:/var/www/html/storage \
  -e DB_HOST=monica-db \
  -e DB_USERNAME=monica \
  -e DB_PASSWORD=changeme \
  -e DB_DATABASE=monica \
  -e APP_ENV=production \
  -p 8081:80 \
  --network proxy \
  monica:latest
```

## Additional Notes / Gotchas

- After making changes via the database, run `php artisan migrate` inside the Monica container to apply schema changes.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: MONICA_DEV
Compose file path: monica_dev/compose.yaml
Additional env file (optional): monica_dev/sample.env

Then "Load" monica_dev/sample.env into the Environmental variables in dockhand

Create the Stack
