# Twenty CRM

## Overview

Modern open-source CRM system for managing customers and pipelines.

## Project Details

-   **Project Repository:** [GitHub](https://github.com/twentyhq/twenty)
-   **Container Image:** [twentycrm/twenty](https://hub.docker.com/r/twentycrm/twenty)
-   **Documentation:** [twenty.com](https://twenty.com/developers/section/self-hosting)
-   **Reverse Proxy Port:** `3000`

## Getting Started

1. Start the container: `docker compose up -d`
2. Open http://localhost:3000 in your browser
3. Follow the initial setup wizard to configure the application

## Environment Variable Notes

    TWENTY_APP_SECRET – generate with `openssl rand -base64 32`
    TWENTY_SERVER_URL – public URL of the instance

## Volume Notes

    /app/packages/twenty-server/.local-storage – uploaded files (shared by server and worker)
    /var/lib/postgresql/data – PostgreSQL data

## Network Notes

Requires proxy network

## Docker Run

```bash
docker run -d \
  --name twenty \
  -p 3000:3000 \
  -e SERVER_URL=http://localhost:3000 \
  -e APP_SECRET=changeme \
  -e PG_DATABASE_URL=postgres://twenty:pass@dbhost:5432/default \
  -e REDIS_URL=redis://redishost:6379 \
  twentycrm/twenty:latest
```

## Additional Notes / Gotchas

The worker container is required for background jobs (sync, imports). Both containers must share the same APP_SECRET and storage volume.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: twenty_dev
Compose file path: twenty_dev/compose.yaml
Additional env file (optional): twenty_dev/sample.env

Then "Load" twenty_dev/sample.env into the Environmental variables in dockhand

Create the Stack
