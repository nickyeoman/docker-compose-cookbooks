# Tinyauth

## Overview

Minimal authentication proxy middleware for securing apps behind a login screen.

## Project Details

-   **Project Repository:** [GitHub](https://github.com/steveiliop56/tinyauth)
-   **Container Image:** [ghcr.io/steveiliop56/tinyauth](https://github.com/steveiliop56/tinyauth/pkgs/container/tinyauth)
-   **Documentation:** [tinyauth.app](https://tinyauth.app/docs/getting-started/)
-   **Reverse Proxy Port:** `3000`

## Getting Started

1. Start the container: `docker compose up -d`
2. Open http://localhost:3000 in your browser
3. Follow the initial setup wizard to configure the application

## Environment Variable Notes

    TINYAUTH_APPURL – public URL of the tinyauth instance
    TINYAUTH_AUTH_USERS – user:bcrypt-hash pairs; generate with `docker run -i -t --rm ghcr.io/steveiliop56/tinyauth:v5 user create --interactive`
    Note: `$` in bcrypt hashes must be escaped as `$$` inside compose files

## Volume Notes

    None — tinyauth is stateless

## Network Notes

Requires proxy network

## Docker Run

```bash
docker run -d \
  --name tinyauth \
  -p 3000:3000 \
  -e TINYAUTH_APPURL=http://localhost:3000 \
  -e 'TINYAUTH_AUTH_USERS=user:$2a$10$hash' \
  ghcr.io/steveiliop56/tinyauth:v5
```

## Additional Notes / Gotchas

Tinyauth is forward-auth middleware — it protects apps via your reverse proxy (Traefik/NPM/Caddy) rather than being visited directly. Nginx Proxy Manager guide: https://tinyauth.app/docs/guides/nginx-proxy-manager/

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: tinyauth_dev
Compose file path: tinyauth_dev/compose.yaml
Additional env file (optional): tinyauth_dev/sample.env

Then "Load" tinyauth_dev/sample.env into the Environmental variables in dockhand

Create the Stack
