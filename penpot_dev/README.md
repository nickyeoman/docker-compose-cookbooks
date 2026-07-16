# https://penpot.app/

## Overview

Open-source design and prototyping tool (Figma alternative).

## Project Details

-   **Container Image:** [penpotapp/frontend:latest](https://hub.docker.com/r/penpotapp/frontend)
-   **Reverse Proxy Port:** `8080`

## Getting Started

1. Start the container: `docker compose up -d`
2. Open http://localhost:9001 in your browser
3. Follow the initial setup wizard to configure the application

## Environment Variable Notes

    PENPOT_FLAGS – default: disable-email-verification enable-smtp enable-prepl-server disable-secure-session-cookies
    PENPOT_PUBLIC_URI – default: http://localhost:9001
    PENPOT_BODY_SIZE – default: 31457280
    PENPOT_MULTIPART_SIZE – default: 367001600
    PENPOT_SMTP_FROM – default: no-reply@example.com
    PENPOT_TELEMETRY – default: true
    PENPOT_PORT – default: 9001

## Volume Notes

    /var/lib/postgresql/data – host path /data/penpot/postgres
    /opt/data/assets – host path /data/penpot/assets
    /opt/data/assets – host path /data/penpot/assets

## Network Notes

Requires proxy network

## Docker Run

```bash
docker run -d \
  --name penpot \
  -p 9001:8080 \
  -v /data/penpot/postgres:/var/lib/postgresql/data \
  -v /data/penpot/assets:/opt/data/assets \
  -v /data/penpot/assets:/opt/data/assets \
  penpotapp/frontend:latest
```

See compose.yaml for the full set of environment variables.

## Additional Notes / Gotchas

Nothing specific to this stack so far.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: penpot_dev
Compose file path: penpot_dev/compose.yaml
Additional env file (optional): penpot_dev/sample.env

Then "Load" penpot_dev/sample.env into the Environmental variables in dockhand

Create the Stack
