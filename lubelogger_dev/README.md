# LubeLogger

This container is for internal use only.
There is no user management.
You could put it behind a reverse proxy. 
Uses sqlite by default but postgres is an option too.

[Getting Started Wiki](https://docs.lubelogger.com/Installation/Getting%20Started)

## Overview

Vehicle maintenance records and fuel mileage tracker.

## Project Details

-   **Container Image:** [ghcr.io/hargata/lubelogger:latest](https://github.com/hargata/lubelogger)
-   **Reverse Proxy Port:** `8080`

## Getting Started

1. Start the container: `docker compose up -d`
2. Open http://localhost:8080 in your browser
3. Follow the initial setup wizard to configure the application

## Environment Variable Notes

    LUBELOGGER_PORT – default: 8080

## Volume Notes

    /App/data – host path /data/lubelogger/data
    /root/.aspnet/DataProtection-Keys – host path /data/lubelogger/keys

## Network Notes

Requires proxy network

## Docker Run

```bash
docker run -d \
  --name lubelogger \
  -p 8080:8080 \
  -v /data/lubelogger/data:/App/data \
  -v /data/lubelogger/keys:/root/.aspnet/DataProtection-Keys \
  ghcr.io/hargata/lubelogger:latest
```

See compose.yaml for the full set of environment variables.

## Additional Notes / Gotchas

Nothing specific to this stack so far.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: lubelogger_dev
Compose file path: lubelogger_dev/compose.yaml
Additional env file (optional): lubelogger_dev/sample.env

Then "Load" lubelogger_dev/sample.env into the Environmental variables in dockhand

Create the Stack
