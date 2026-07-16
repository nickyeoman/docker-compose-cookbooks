# Outline

## Overview

Team knowledge base and documentation wiki.

## Project Details

-   **Project Repository:** [GitHub](https://github.com/outline/outline)
-   **Container Image:** [outlinewiki/outline](https://hub.docker.com/r/outlinewiki/outline)
-   **Documentation:** [docs.getoutline.com](https://docs.getoutline.com/s/hosting)
-   **Reverse Proxy Port:** `3000`

## Getting Started

1. Start the container: `docker compose up -d`
2. Open http://localhost:3000 in your browser
3. Follow the initial setup wizard to configure the application

## Environment Variable Notes

    OUTLINE_SECRET_KEY / OUTLINE_UTILS_SECRET – generate each with `openssl rand -hex 32`
    OUTLINE_URL – public URL, must match how you access it

## Volume Notes

    /var/lib/outline/data – local file/attachment storage
    /var/lib/postgresql/data – PostgreSQL data

## Network Notes

Requires proxy network

## Docker Run

```bash
docker run -d \
  --name outline \
  -p 3000:3000 \
  -e URL=http://localhost:3000 \
  -e SECRET_KEY=$(openssl rand -hex 32) \
  -e UTILS_SECRET=$(openssl rand -hex 32) \
  -e DATABASE_URL=postgres://outline:pass@dbhost:5432/outline \
  -e PGSSLMODE=disable \
  -e REDIS_URL=redis://redishost:6379 \
  outlinewiki/outline:latest
```

## Additional Notes / Gotchas

Outline has no built-in username/password login — you must configure an auth provider (OIDC, Google, Slack, etc.) via additional env vars before anyone can sign in. Authentik or Authelia from this repo work as OIDC providers.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: outline_dev
Compose file path: outline_dev/compose.yaml
Additional env file (optional): outline_dev/sample.env

Then "Load" outline_dev/sample.env into the Environmental variables in dockhand

Create the Stack
