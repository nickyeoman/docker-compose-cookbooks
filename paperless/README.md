# Paperless

## Overview

Document management system that indexes your scanned paperwork.

## Project Details

-   **Project Repository:** [Link](https://github.com/paperless-ngx/paperless-ngx)
-   **Container Image:** [Github](https://github.com/paperless-ngx/paperless-ngx)
-   **Compose Example:** [Compose](https://github.com/paperless-ngx/paperless-ngx/blob/main/docker/compose/docker-compose.mariadb-tika.yml)
-   **Documentation:** [Docs](https://docs.paperless-ngx.com/)
-   **Reverse Proxy Port:** `8000`

## Getting Started

1. Start the container: `docker compose up -d`
2. Open http://localhost:8000 in your browser
3. Follow the initial setup wizard to configure the application

## Environment Variable Notes

    PAPERLESS_MARIADB_DATABASE – default: paperless
    PAPERLESS_MARIADB_USER – default: paperless
    PAPERLESS_MARIADB_PASSWORD – default: ChangeThisPassword
    PAPERLESS_MARIADB_ROOT_PASSWORD – default: ChangeThisPassword
    PAPERLESS_SECRET_KEY – default: ChangeThisPassword
    PAPERLESS_OCR_LANGUAGE – default: eng
    PAPERLESS_URL – default: http://localhost
    PAPERLESS_CONSUMER_DELETE_DUPLICATES – default: 0
    PAPERLESS_PORT – default: 8000

## Volume Notes

    /data – host path /data/paperless/redis
    /var/lib/mysql – host path /data/paperless/db
    /usr/src/paperless/data – host path /data/paperless/data
    /usr/src/paperless/media – host path /data/paperless/media
    /usr/src/paperless/export – host path /data/paperless/export
    /usr/src/paperless/consume – host path /data/paperless/consume

## Network Notes

Requires proxy network

## Docker Run

```bash
docker run -d \
  --name paperless \
  -p 8000:8000 \
  -v /data/paperless/redis:/data \
  -v /data/paperless/db:/var/lib/mysql \
  -v /data/paperless/data:/usr/src/paperless/data \
  -v /data/paperless/media:/usr/src/paperless/media \
  -v /data/paperless/export:/usr/src/paperless/export \
  ghcr.io/paperless-ngx/paperless-ngx:latest
```

See compose.yaml for the full set of environment variables.

## Additional Notes / Gotchas

Nothing specific to this stack so far.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: paperless
Compose file path: paperless/compose.yaml
Additional env file (optional): paperless/sample.env

Then "Load" paperless/sample.env into the Environmental variables in dockhand

Create the Stack

## First Run

It takes a very long time for the first run to initilaze, v
view the log to see when it's ready.

The ui will now create the first user for you, but we used to have to run:

```
docker exec -it paperless-ngx bash
python3 manage.py createsuperuser
```

## Configuration

All settings are controlled via environment variables in your `.env` file. Key variables include:

| Variable | Default | Description |
|----------|---------|-------------|
| `PAPERLESS_IMAGE` | `ghcr.io/paperless-ngx/paperless-ngx:latest` | Paperless Docker image |
| `PAPERLESS_MARIADB_HOST` | `paperless-db` | MariaDB host |
| `PAPERLESS_MARIADB_DATABASE` | `paperless` | Database name |
| `PAPERLESS_MARIADB_USER` | `paperless` | Database user |
| `PAPERLESS_MARIADB_PASSWORD` | `paperless` | Database password |
| `PAPERLESS_MARIADB_ROOT_PASSWORD` | `paperless` | MariaDB root password |
| `PAPERLESS_SECRET_KEY` | `changeme` | Secret key for Paperless |
| `PAPERLESS_OCR_LANGUAGE` | `eng` | OCR language for scanned documents |
| `VOL_PATH` | `./data` | Base path for volume storage |
| `TZ` | `America/Vancouver` | Timezone |

You can adjust these values in your `.env` (drived from `sample.env`) file before starting the containers.  

For the full list of available options, see the [Paperless-ngx configuration documentation](http://docs.paperless-ngx.com/configuration/).
