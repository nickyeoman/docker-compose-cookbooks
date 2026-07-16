# Maybe Finance

## Overview

Personal finance and budgeting tool with a focus on privacy.

## Project Details

-   **Project Repository:** [GitHub](https://github.com/maybe-finance/maybe)
-   **Container Image:** [ghcr.io/maybe-finance/maybe](https://github.com/maybe-finance/maybe/pkgs/container/maybe)
-   **Documentation:** [GitHub docs](https://github.com/maybe-finance/maybe/tree/main/docs)
-   **Reverse Proxy Port:** `3000`

## Getting Started

1. Start the container: `docker compose up -d`
2. Open http://localhost:3000 in your browser
3. Follow the initial setup wizard to configure the application

## Environment Variable Notes

    MAYBE_SECRET_KEY_BASE – generate with `openssl rand -hex 64`

## Volume Notes

    /rails/storage – uploaded files
    /var/lib/postgresql/data – PostgreSQL data

## Network Notes

Requires proxy network

## Docker Run

```bash
docker run -d \
  --name maybe \
  -p 3000:3000 \
  -e SELF_HOSTED=true -e RAILS_FORCE_SSL=false -e RAILS_ASSUME_SSL=false \
  -e SECRET_KEY_BASE=changeme \
  -e DB_HOST=dbhost -e POSTGRES_USER=maybe -e POSTGRES_PASSWORD=pass -e POSTGRES_DB=maybe \
  ghcr.io/maybe-finance/maybe:latest
```

## Additional Notes / Gotchas

The Maybe company shut down and archived the repo — the image is frozen and receives no updates. Consider firefly_dev or paisa_dev in this repo as maintained alternatives.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: maybe_dev
Compose file path: maybe_dev/compose.yaml
Additional env file (optional): maybe_dev/sample.env

Then "Load" maybe_dev/sample.env into the Environmental variables in dockhand

Create the Stack
