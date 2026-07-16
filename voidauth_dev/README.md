# VoidAuth

## Overview

Lightweight self-hosted authentication system (SSO / identity provider).

## Project Details

-   **Project Repository:** [GitHub](https://github.com/voidauth/voidauth)
-   **Container Image:** [voidauth/voidauth](https://hub.docker.com/r/voidauth/voidauth)
-   **Documentation:** [voidauth.app](https://voidauth.app/)
-   **Reverse Proxy Port:** `3000`

## Getting Started

1. Start the container: `docker compose up -d`
2. Open http://localhost:3000 in your browser
3. Follow the initial setup wizard to configure the application

## Environment Variable Notes

    VOIDAUTH_STORAGE_KEY – encryption key, generate with `openssl rand -hex 32`; do not change after setup
    VOIDAUTH_APP_URL – public URL of the instance

## Volume Notes

    /var/lib/postgresql/data – PostgreSQL data

## Network Notes

Requires proxy network

## Docker Run

```bash
docker run -d \
  --name voidauth \
  -p 3000:3000 \
  -e APP_URL=http://localhost:3000 \
  -e STORAGE_KEY=changeme \
  -e DB_HOST=dbhost -e DB_PASSWORD=pass \
  voidauth/voidauth:latest
```

## Additional Notes / Gotchas

See also authentik_dev, authelia_dev, and tinyauth_dev in this repo for alternative auth stacks.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: voidauth_dev
Compose file path: voidauth_dev/compose.yaml
Additional env file (optional): voidauth_dev/sample.env

Then "Load" voidauth_dev/sample.env into the Environmental variables in dockhand

Create the Stack
