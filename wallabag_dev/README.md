# Wallabag

## Overview

Wallabag is a self-hosted read-it-later application: save web pages,
tag them, and read them later (including offline via the Android/iOS
apps after sync). This stack runs Wallabag with a MariaDB database.

## Project Details

-   **Project Repository:** [github.com/wallabag/wallabag](https://github.com/wallabag/wallabag)
-   **Container Image:** [Docker Hub](https://hub.docker.com/r/wallabag/wallabag)
-   **Compose Example:** [github.com/wallabag/docker](https://github.com/wallabag/docker)
-   **Documentation:** [doc.wallabag.org](https://doc.wallabag.org/)
-   **Reverse Proxy Port:** `80`

## Getting Started

1. Copy `sample.env` and set `WALLABAG_DOMAIN` and the database
   passwords
2. Start the containers: `docker compose up -d` (first start runs the
   database install and can take a minute or two)
3. Open http://localhost:8082 in your browser and sign in with the
   default `wallabag` / `wallabag` account — change its password
   immediately

## Environment Variable Notes

    WALLABAG_DOMAIN – public base URL; must match how users reach the
      site or logins and asset links break
    WALLABAG_DB_NAME / WALLABAG_DB_USER / WALLABAG_DB_PASSWORD –
      database name and credentials, shared by both services
    WALLABAG_MYSQL_ROOT_PASSWORD – MariaDB root password; the wallabag
      container also needs it to create the database on first start
    WALLABAG_MAILER_DSN / WALLABAG_FROM_EMAIL – optional SMTP settings
      for password-reset and notification emails
    WALLABAG_PORT – host port for the web UI (default 8082)

See the [parameter documentation](https://doc.wallabag.org/en/admin/parameters.html)
for the full list of `SYMFONY__ENV__` settings.

## Volume Notes

-   `/var/www/wallabag/web/assets/images` — saved article images;
    stored at `${VOL_PATH:-/data}/wallabag/images` on the host
-   `/var/lib/mysql` — MariaDB data; stored at
    `${VOL_PATH:-/data}/wallabag/db` on the host

## Network Notes

Requires proxy network. The database is only attached to the stack's
`internal` network.

## Docker Run

Not recommended — Wallabag needs its MariaDB companion. Use the
compose file.

## Additional Notes / Gotchas

-   This is a `_dev` stack — experimental, not yet production-ready.
-   The default login after install is `wallabag` / `wallabag`.
-   `SYMFONY__ENV__` variables are baked into Wallabag's config on
    startup; after changing one, restart the container.

## References

-   [Geek Cookbook](https://geek-cookbook.funkypenguin.co.nz/recipes/wallabag/)

## Dockhand Stack, Deploy from Git

-   Cookbooks Repository
-   stackname: wallabag_dev
-   Compose file path: wallabag_dev/compose.yaml
-   Additional env file (optional): wallabag_dev/sample.env

Then "Load" wallabag_dev/sample.env into the Environment variables in dockhand.

Create the Stack
