# YOURLS

## Overview

YOURLS (Your Own URL Shortener) is a self-hosted URL shortener with
link statistics, a bookmarklet, and a plugin API. This stack runs
YOURLS with a MariaDB database.

## Project Details

-   **Project Repository:** [github.com/YOURLS/YOURLS](https://github.com/YOURLS/YOURLS)
-   **Container Image:** [Docker Hub](https://hub.docker.com/_/yourls)
-   **Documentation:** [yourls.org](https://yourls.org/)
-   **Reverse Proxy Port:** `80`

## Getting Started

1. Copy `sample.env` and set `YOURLS_SITE`, the admin login, and the
   database passwords
2. Start the containers: `docker compose up -d`
3. Open http://localhost:8080/admin/ in your browser and run the
   install step, then sign in with `YOURLS_USER` / `YOURLS_PASS`

## Environment Variable Notes

    YOURLS_SITE – public base URL used in generated short links; must
      match how users reach the site (domain behind the proxy)
    YOURLS_USER / YOURLS_PASS – admin login for the /admin/ interface
    YOURLS_DB_NAME / YOURLS_DB_USER / YOURLS_DB_PASSWORD – database
      name and credentials, shared by both services
    YOURLS_MYSQL_ROOT_PASSWORD – MariaDB root password
    YOURLS_PORT – host port for the web UI (default 8080)

## Volume Notes

-   `/var/www/html` — YOURLS application files and plugins; stored at
    `${VOL_PATH:-/data}/yourls/html` on the host
-   `/var/lib/mysql` — MariaDB data; stored at
    `${VOL_PATH:-/data}/yourls/db` on the host

## Network Notes

Requires proxy network. The database is only attached to the stack's
`internal` network.

## Docker Run

Not recommended — YOURLS needs its MariaDB companion. Use the compose
file.

## Additional Notes / Gotchas

-   This is a `_dev` stack — experimental, not yet production-ready.
-   The admin interface is at `/admin/`, not the site root.
-   Changing `YOURLS_SITE` after install does not rewrite existing
    short links; set it correctly before creating links.

## Dockhand Stack, Deploy from Git

-   Cookbooks Repository
-   stackname: yourls_dev
-   Compose file path: yourls_dev/compose.yaml
-   Additional env file (optional): yourls_dev/sample.env

Then "Load" yourls_dev/sample.env into the Environment variables in dockhand.

Create the Stack
