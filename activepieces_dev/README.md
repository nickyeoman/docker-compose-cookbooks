# Activepieces

## Overview

Activepieces is an open-source automation platform. This stack runs Activepieces with PostgreSQL and Redis.

## Project Details

-   **Project Repository:** [https://github.com/activepieces/activepieces](https://github.com/activepieces/activepieces)
-   **Container Image:** [GitHub Packages](https://github.com/activepieces/activepieces/pkgs/container/activepieces)
-   **Documentation:** [https://www.activepieces.com/docs](https://www.activepieces.com/docs)
-   **Reverse Proxy Port:** `80`

## Getting Started

1. Generate secrets and set them in your environment:
   ```bash
   export AP_ENCRYPTION_KEY=$(openssl rand -hex 16)
   export AP_JWT_SECRET=$(openssl rand -hex 32)
   ```
2. Start the stack: `docker compose up -d`
3. Open http://localhost:8080 in your browser

## Environment Variable Notes

    VOL_PATH – base path for persistent data volumes
    VOL_PROJECTS – base path for project directories
    ACTIVEPIECES_IMAGE – Activepieces container image (default: ghcr.io/activepieces/activepieces:0.44.0)
    ACTIVEPIECES_RESTART – restart policy (default: unless-stopped)
    ACTIVEPIECES_PORT – host port mapped to container port 80 (default: 8080)
    ACTIVEPIECES_DOMAIN – domain for frontend URL
    AP_ENCRYPTION_KEY – 256-bit encryption key (32 hex chars, default: changeme – generate with `openssl rand -hex 16`)
    AP_JWT_SECRET – JWT signing secret (default: changeme – generate with `openssl rand -hex 32`)
    AP_POSTGRES_PASSWORD – PostgreSQL password

## Volume Notes

    ${VOL_PATH}/activepieces_dev/cache – Activepieces cache files
    ${VOL_PATH}/activepieces_dev/postgres – PostgreSQL data directory
    ${VOL_PATH}/activepieces_dev/redis – Redis data directory

## Network Notes

Requires the external `proxy` network (Nginx Proxy Manager). An internal bridge network `internal` is created for inter-service communication.

## Docker Run

```bash
docker run -d \
  --name activepieces \
  -v ${VOL_PATH:-/data}/activepieces_dev/cache:/usr/src/app/cache \
  -e AP_ENCRYPTION_KEY=your-32-hex-char-key \
  -e AP_JWT_SECRET=your-secret \
  -e AP_POSTGRES_PASSWORD=changeme \
  -e AP_POSTGRES_HOST=postgres \
  -e AP_REDIS_HOST=redis \
  -p 8080:80 \
  --network proxy \
  ghcr.io/activepieces/activepieces:0.44.0
```

## Additional Notes / Gotchas

- `AP_ENCRYPTION_KEY` and `AP_JWT_SECRET` are required and must be set before the first run. Changing them after data has been written will cause errors.
- Activepieces requires the `UNSANDBOXED` execution mode in Docker; switch to `SANDBOXED` if you need isolation (requires `privileged: true`).

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: ACTIVEPIECES_DEV
Compose file path: activepieces_dev/compose.yaml
Additional env file (optional): activepieces_dev/sample.env

Then "Load" activepieces_dev/sample.env into the Environmental variables in dockhand

Create the Stack
