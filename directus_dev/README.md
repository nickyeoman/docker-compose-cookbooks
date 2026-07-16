# Directus

[official Website](https://directus.io/) and [Documentation](https://docs.directus.io/)

[Docker Hub](https://hub.docker.com/r/directus/directus)

Proxy port: 8055

## Overview

Instant headless CMS and admin app layered on top of a SQL database.

## Project Details

-   **Container Image:** [directus/directus:latest](https://hub.docker.com/r/directus/directus)
-   **Reverse Proxy Port:** `8055`

## Getting Started

1. Start the container: `docker compose up -d`
2. Open http://localhost:8000 in your browser
3. Follow the initial setup wizard to configure the application

## Environment Variable Notes

    MARIADB_DATABASE – default: directus
    MARIADB_USER – default: directus
    MARIADB_PASSWORD – default: ChangeThisPassword
    MARIADB_ROOT_PASSWORD – default: ChangeThisPassword
    DIRECTUS_SECRET – default: ChangeThisPassword
    DIRECTUS_ADMIN_EMAIL – default: noreply@example.com
    DIRECTUS_ADMIN_PASSWORD – default: ChangeThisPassword
    DIRECTUS_PUBLIC_URL – default: http://localhost:8055
    DIRECTUS_PORT – default: 8000

## Volume Notes

    /var/lib/mysql – host path /data/directus/db
    /directus/uploads – host path /data/directus/uploads
    /directus/extensions – host path /data/directus/extensions
    /directus/templates – host path /data/directus/templates

## Network Notes

Requires proxy network

## Docker Run

```bash
docker run -d \
  --name directus \
  -p 8000:8055 \
  -v /data/directus/db:/var/lib/mysql \
  -v /data/directus/uploads:/directus/uploads \
  -v /data/directus/extensions:/directus/extensions \
  -v /data/directus/templates:/directus/templates \
  directus/directus:latest
```

See compose.yaml for the full set of environment variables.

## Additional Notes / Gotchas

Nothing specific to this stack so far.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: directus_dev
Compose file path: directus_dev/compose.yaml
Additional env file (optional): directus_dev/sample.env

Then "Load" directus_dev/sample.env into the Environmental variables in dockhand

Create the Stack

## Other  Containers

You will also need mariadb and redis, something like:

```
  mariadb:
    image: ${MARIADB_IMAGE:-mariadb:latest}
    restart: unless-stopped
    environment:
      - MARIADB_DATABASE=${MARIADB_DATABASE}
      - MARIADB_ROOT_PASSWORD=${MARIADB_ROOT_PASSWORD}
      - MARIADB_USER=${MARIADB_USER}
      - MARIADB_PASSWORD=${MARIADB_PASSWORD}
    volumes:
      - ${VOL_PATH}/mariadb:/var/lib/mysql
    
  cache:
    image: redis:6
    healthcheck:
      test: ["CMD-SHELL", "[ $$(redis-cli ping) = 'PONG' ]"]
      interval: 10s
      timeout: 5s
      retries: 5
      start_interval: 5s
      start_period: 30s
```

## Gotacha

On first run: The initial admin email address and password will be shown in the terminal. 
If you forgot and did a detached: ```docker compose logs -f```

Reset password:
```bash
sudo nala install argon2
echo -n "TheNewPasswordHere" | argon2 "$(openssl rand -base64 16)" -id -m 16 -t 3 -p 4
```
