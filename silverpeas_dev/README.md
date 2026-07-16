# Silverpeas

## Overview

Enterprise collaboration platform: intranet, document sharing, and communication tools.

## Project Details

-   **Project Repository:** [silverpeas.org](https://www.silverpeas.org/)
-   **Container Image:** [silverpeas](https://hub.docker.com/_/silverpeas)
-   **Documentation:** [Docker Hub](https://hub.docker.com/_/silverpeas)
-   **Reverse Proxy Port:** `8000`

## Getting Started

1. Start the container: `docker compose up -d`
2. Open http://localhost:8000 in your browser
3. Follow the initial setup wizard to configure the application

## Environment Variable Notes

    SILVERPEAS_DB_PASSWORD – shared between the app and postgres

## Volume Notes

    /opt/silverpeas/data – documents and application data
    /opt/silverpeas/log – logs
    /var/lib/postgresql/data – PostgreSQL data

## Network Notes

Requires proxy network

## Docker Run

```bash
docker run -d \
  --name silverpeas \
  -p 8000:8000 \
  -e DB_SERVERTYPE=POSTGRESQL -e DB_SERVER=dbhost \
  -e DB_NAME=silverpeas -e DB_USER=silverpeas -e DB_PASSWORD=pass \
  silverpeas:latest
```

## Additional Notes / Gotchas

The app is served under the `/silverpeas` path (http://localhost:8000/silverpeas). Default admin is SilverAdmin/SilverAdmin — change it.
First startup is slow (Wildfly + DB migration).

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: silverpeas_dev
Compose file path: silverpeas_dev/compose.yaml
Additional env file (optional): silverpeas_dev/sample.env

Then "Load" silverpeas_dev/sample.env into the Environmental variables in dockhand

Create the Stack
