# Poste.io

[Documentation](https://poste.io/doc/)

## Overview

All-in-one mail server: SMTP, IMAP, webmail, antispam, and admin UI.

## Project Details

-   **Container Image:** [analogic/poste.io:latest](https://hub.docker.com/r/analogic/poste.io)
-   **Reverse Proxy Port:** `25`

## Getting Started

1. Start the container: `docker compose up -d`
2. Open http://localhost:25 in your browser
3. Follow the initial setup wizard to configure the application

## Environment Variable Notes

    POSTE_HOSTNAME – default: mail.yourdomain.com
    POSTE_SMTP_PORT – default: 25
    POSTE_POP3_PORT – default: 110
    POSTE_IMAP_PORT – default: 143
    POSTE_SUBMISSION_PORT – default: 587
    POSTE_IMAPS_PORT – default: 993
    POSTE_POP3S_PORT – default: 995
    POSTE_SIEVE_PORT – default: 4190

## Volume Notes

    /data – host path /data/poste

## Network Notes

Requires proxy network

## Docker Run

```bash
docker run -d \
  --name poste \
  -p 25:25 \
  -p 110:110 \
  -p 143:143 \
  -v /data/poste:/data \
  analogic/poste.io:latest
```

See compose.yaml for the full set of environment variables.

## Additional Notes / Gotchas

Nothing specific to this stack so far.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: poste_dev
Compose file path: poste_dev/compose.yaml
Additional env file (optional): poste_dev/sample.env

Then "Load" poste_dev/sample.env into the Environmental variables in dockhand

Create the Stack
