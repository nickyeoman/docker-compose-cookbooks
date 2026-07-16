# Chatwoot

## Overview

Open-source customer support and live chat platform.

## Project Details

-   **Project Repository:** [GitHub](https://github.com/chatwoot/chatwoot)
-   **Container Image:** [chatwoot/chatwoot](https://hub.docker.com/r/chatwoot/chatwoot)
-   **Documentation:** [chatwoot.com](https://www.chatwoot.com/docs/self-hosted)
-   **Reverse Proxy Port:** `3000`

## Getting Started

1. Start the container: `docker compose up -d`
2. Open http://localhost:3000 in your browser
3. Follow the initial setup wizard to configure the application

## Environment Variable Notes

    CHATWOOT_SECRET_KEY_BASE – generate with `openssl rand -hex 64`
    CHATWOOT_FRONTEND_URL – public URL of the instance

## Volume Notes

    /app/storage – uploaded attachments (shared by rails and sidekiq)
    /var/lib/postgresql/data – PostgreSQL data (pgvector image required)

## Network Notes

Requires proxy network

## Docker Run

```bash
docker run -d \
  --name chatwoot \
  -p 3000:3000 \
  -e SECRET_KEY_BASE=changeme \
  -e FRONTEND_URL=http://localhost:3000 \
  -e POSTGRES_HOST=dbhost -e POSTGRES_USERNAME=chatwoot \
  -e POSTGRES_PASSWORD=pass -e REDIS_URL=redis://redishost:6379 \
  chatwoot/chatwoot:latest bundle exec rails s -p 3000 -b 0.0.0.0
```

## Additional Notes / Gotchas

Before first run, prepare the database once:
`docker compose run --rm chatwoot bundle exec rails db:chatwoot_prepare`
Chatwoot requires the pgvector Postgres extension, hence the pgvector image.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: chatwoot_dev
Compose file path: chatwoot_dev/compose.yaml
Additional env file (optional): chatwoot_dev/sample.env

Then "Load" chatwoot_dev/sample.env into the Environmental variables in dockhand

Create the Stack
