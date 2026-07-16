# SUITE CRM

proxyport 8080


See documentation: https://hub.docker.com/r/bitnami/suitecrm

## Overview

Open-source customer relationship management platform (SugarCRM fork).

## Project Details

-   **Container Image:** [bitnami/suitecrm:latest](https://hub.docker.com/r/bitnami/suitecrm)
-   **Reverse Proxy Port:** `8080`

## Getting Started

1. Start the container: `docker compose up -d`
2. Open http://localhost:8080 in your browser
3. Follow the initial setup wizard to configure the application

## Environment Variable Notes

    SUITECRM_DB_PASSWORD – default: ChangeThisPassword
    MARIADB_ROOT_PASSWORD – default: ChangeThisPassword
    SUITECRM_USER – default: admin
    SUITECRM_PASS – default: ChangeThisPassword
    SUITECRM_PORT – default: 8080

## Volume Notes

    /var/lib/mysql – host path /data/suitecrm/db
    /bitnami/suitecrm – host path /data/suitecrm/data

## Network Notes

Requires proxy network

## Docker Run

```bash
docker run -d \
  --name suitecrm \
  -p 8080:8080 \
  -v /data/suitecrm/db:/var/lib/mysql \
  -v /data/suitecrm/data:/bitnami/suitecrm \
  bitnami/suitecrm:latest
```

See compose.yaml for the full set of environment variables.

## Additional Notes / Gotchas

Nothing specific to this stack so far.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: suitecrm_dev
Compose file path: suitecrm_dev/compose.yaml
Additional env file (optional): suitecrm_dev/sample.env

Then "Load" suitecrm_dev/sample.env into the Environmental variables in dockhand

Create the Stack

## Gotchas

1. they sometimes change variable names.

### imap

imap is not enabled by default as it's last update was 2011.

I don't yet have a process of updating this container for imap.  Looking for alternative container providers.
