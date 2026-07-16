# nextcloud

Docker Hub: https://hub.docker.com/_/nextcloud
Proxy Port: 80

## Overview

Self-hosted file sync, sharing, and collaboration platform.

## Project Details

-   **Container Image:** [mariadb:latest](https://hub.docker.com/_/mariadb)
-   **Reverse Proxy Port:** `n/a`

## Getting Started

1. Start the container: `docker compose up -d`
2. Open http://localhost:PORT in your browser
3. Follow the initial setup wizard to configure the application

## Environment Variable Notes

    NEXTCLOUD_DB – default: nextcloud
    MARIADB_ROOT_PASSWORD – default: ChangeThisPassword
    NEXTCLOUD_DB_USER – default: nextcloud
    NEXTCLOUD_DB_PASSWORD – default: ChangeThisPassword
    NEXTCLOUD_DB_HOST – default: nextcloud-db

## Volume Notes

    /var/lib/mysql – host path /data/nextcloud/db
    /var/www/html – host path /data/nextcloud/data

## Network Notes

Requires proxy network

## Docker Run

```bash
docker run -d \
  --name nextcloud \
  -v /data/nextcloud/db:/var/lib/mysql \
  -v /data/nextcloud/data:/var/www/html \
  mariadb:latest
```

See compose.yaml for the full set of environment variables.

## Additional Notes / Gotchas

See `compose-aio.yaml` in this directory for the Nextcloud All-in-One variant.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: nextcloud
Compose file path: nextcloud/compose.yaml
Additional env file (optional): nextcloud/sample.env

Then "Load" nextcloud/sample.env into the Environmental variables in dockhand

Create the Stack

## Useful commands

```bash
sudo -u www-data php occ app:list
sudo -u www-data php occ app:disable <appname>
sudo -u www-data php occ maintenance:mode --on
php occ trashbin:cleanup --all-users

docker-compose exec --user www-data nextcloud php occ
```
