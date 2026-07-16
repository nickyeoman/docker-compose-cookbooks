# Duplicati

Proxy port: 8200

## Overview

Encrypted backup software for securely storing backups to cloud or local destinations.

## Project Details

-   **Container Image:** [duplicati/duplicati:latest](https://hub.docker.com/r/duplicati/duplicati)
-   **Reverse Proxy Port:** `8200`

## Getting Started

1. Start the container: `docker compose up -d`
2. Open http://localhost:8200 in your browser
3. Follow the initial setup wizard to configure the application

## Environment Variable Notes

    DUPLICATI_KEY – default: ChangeThisPassword
    DUPLICATI_PASS – default: ChangeThisPassword
    DUPLICATI_PORT – default: 8200

## Volume Notes

    /data – host path /data/duplicati/config
    /backups – host path /data/duplicati/backups
    /source – host path /data/duplicati/source
    /restore – host path /data/duplicati/restore

## Network Notes

Requires proxy network

## Docker Run

```bash
docker run -d \
  --name duplicati \
  -p 8200:8200 \
  -v /data/duplicati/config:/data \
  -v /data/duplicati/backups:/backups \
  -v /data/duplicati/source:/source:ro \
  -v /data/duplicati/restore:/restore \
  duplicati/duplicati:latest
```

See compose.yaml for the full set of environment variables.

## Additional Notes / Gotchas

Nothing specific to this stack so far.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: duplicati_dev
Compose file path: duplicati_dev/compose.yaml
Additional env file (optional): duplicati_dev/sample.env

Then "Load" duplicati_dev/sample.env into the Environmental variables in dockhand

Create the Stack
