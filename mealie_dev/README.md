# mealie

Last Updated: Thu August 08, 2024 15:15:31 PDT

## Overview

Docker Hub: https://hub.docker.com/r/hkotel/mealie
Project: https://mealie.io/
Proxy Port: 9000

## Project Details

-   **Container Image:** [hkotel/mealie:latest](https://hub.docker.com/r/hkotel/mealie)
-   **Reverse Proxy Port:** `80`

## Getting Started

1. Start the container: `docker compose up -d`
2. Open http://localhost:9000 in your browser
3. Follow the initial setup wizard to configure the application

## Environment Variable Notes

    MEALIE_BASE_URL – default: https://mealie.domain.com
    MEALIE_DEFAULT_EMAIL – default: email@domain.com
    MEALIE_PGID – default: 1000
    MEALIE_PUID – default: 1000
    MEALIE_RECIPE_DISABLE_AMOUNT – default: false
    MEALIE_RECIPE_DISABLE_COMMENTS – default: false
    MEALIE_RECIPE_LANDSCAPE_VIEW – default: true
    MEALIE_RECIPE_PUBLIC – default: true
    MEALIE_RECIPE_SHOW_ASSETS – default: true
    MEALIE_RECIPE_SHOW_NUTRITION – default: true
    MEALIE_PORT – default: 9000

## Volume Notes

    /app/data – host path /data/mealie

## Network Notes

Requires proxy network

## Docker Run

```bash
docker run -d \
  --name mealie \
  -p 9000:80 \
  -v /data/mealie:/app/data \
  hkotel/mealie:latest
```

See compose.yaml for the full set of environment variables.

## Additional Notes / Gotchas

Nothing specific to this stack so far.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: mealie_dev
Compose file path: mealie_dev/compose.yaml
Additional env file (optional): mealie_dev/sample.env

Then "Load" mealie_dev/sample.env into the Environmental variables in dockhand

Create the Stack
