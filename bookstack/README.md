# Bookstack

## Overview

BookStack is a self-hosted wiki platform for organizing and storing documentation in a simple, book/chapter/page structure. This Docker Compose stack allows easy deployment with persistent storage.

## Project Details

-   **Project Repository:** [Bookstack Official](https://www.bookstackapp.com/)
-   **Container Image:** [Docker Hub](https://hub.docker.com/r/solidnerd/bookstack)
-   **Compose Example:** [Compose](https://github.com/solidnerd/docker-bookstack/blob/master/docker-compose.yml)
-   **Documentation:** [Docs](https://www.bookstackapp.com/docs/)
-   **Reverse Proxy Port:** `8080`

## Getting Started

1. Start the container: `docker compose up -d`
2. Open http://localhost:8080 in your browser
3. Follow the initial setup wizard to configure the application

## Environment Variable Notes

    BOOKSTACK_APP_KEY – default: ChangeThisPassword
    BOOKSTACK_APP_TIMEZONE – default: America/Vancouver
    BOOKSTACK_APP_URL – default: http://localhost:8080
    BOOKSTACK_DB_DATABASE – default: bookstack
    BOOKSTACK_DB_PASSWORD – default: ChangeThisPassword
    BOOKSTACK_DB_USERNAME – default: dbuser
    BOOKSTACK_REVISION_LIMIT – default: false
    BOOKSTACK_PORT – default: 8080
    MARIADB_ROOT_PASSWORD – default: ChangeThisPassword

## Volume Notes

    /var/www/bookstack/storage/uploads – host path /data/bookstack/uploads
    /var/www/bookstack/public/uploads – host path /data/bookstack/public
    /var/lib/mysql – host path /data/bookstack/db

## Network Notes

Requires proxy network

## Docker Run

```bash
docker run -d \
  --name bookstack \
  -p 8080:8080 \
  -v /data/bookstack/uploads:/var/www/bookstack/storage/uploads \
  -v /data/bookstack/public:/var/www/bookstack/public/uploads \
  -v /data/bookstack/db:/var/lib/mysql \
  solidnerd/bookstack:latest
```

See compose.yaml for the full set of environment variables.

## Additional Notes / Gotchas

Nothing specific to this stack so far.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: bookstack
Compose file path: bookstack/compose.yaml
Additional env file (optional): bookstack/sample.env

Then "Load" bookstack/sample.env into the Environmental variables in dockhand

Create the Stack

## Notes

### APP_KEY

Generate an APP_KEY: echo -n "base64:"$(openssl rand -base64 32)

### Default Password

* Username/Email: admin@admin.com
* Password: password

After logging in, go to Settings > My Account to update the password (and email if desired). This prevents unauthorized access.
