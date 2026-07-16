# Mailhog

TODO:

```
 mailhog:
    image: 'mailhog/mailhog:latest' # https://hub.docker.com/r/mailhog/mailhog
    ports:
      - "${SMTP_PORT}:1025"
      - "8002:8025"
    volumes:
      - "/etc/timezone:/etc/timezone:ro"
      - "/etc/localtime:/etc/localtime:ro"
```

## Overview

Email testing tool: fake SMTP server with a web UI to inspect captured mail.

## Project Details

-   **Container Image:** [mailhog/mailhog:latest](https://hub.docker.com/r/mailhog/mailhog)
-   **Reverse Proxy Port:** `1025`

## Getting Started

1. Start the container: `docker compose up -d`
2. Open http://localhost:1025 in your browser
3. Follow the initial setup wizard to configure the application

## Environment Variable Notes

    MAILHOG_SMTP_PORT – default: 1025
    MAILHOG_UI_PORT – default: 8025

## Volume Notes

No persistent volumes.

## Network Notes

Requires proxy network

## Docker Run

```bash
docker run -d \
  --name mailhog \
  -p 1025:1025 \
  -p 8025:8025 \
  mailhog/mailhog:latest
```

See compose.yaml for the full set of environment variables.

## Additional Notes / Gotchas

Nothing specific to this stack so far.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: mailhog_dev
Compose file path: mailhog_dev/compose.yaml
Additional env file (optional): mailhog_dev/sample.env

Then "Load" mailhog_dev/sample.env into the Environmental variables in dockhand

Create the Stack
