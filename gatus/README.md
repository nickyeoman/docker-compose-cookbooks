# Gatus

## Overview

Track uptime.

## Project Details

-   **Project Repository:** [Link](https://github.com/TwiN/gatus)
-   **Container Image:** [Docker Hub](https://hub.docker.com/r/twinproduction/gatus)
-   **Documentation:** [Docs](https://gatus.io/)
-   **Reverse Proxy Port:** `8080`

## Getting Started

1. Start the container: `docker compose up -d`
2. Open http://localhost:8080 in your browser
3. Follow the initial setup wizard to configure the application

## Environment Variable Notes

    GATUS_PORT – default: 8080

## Volume Notes

There are two mounts
CONFIG_FILE - Where the yaml config file lives.  Likely stored to a repo somewhere.
VOL_DATA - Which is the persistent data.

Note the db must be set in the config file for persistent to happen.

There is an example config.yaml file in this repo.

## Network Notes

Requires proxy network

## Docker Run

This one would be pretty easy to run on its own:

```
docker run -d \
  -e TZ=America/Vancouver \
  -p 8080:8080 \
  -v /data/config.yml:/config/config.yaml \
  -v /data/gatus:/config/data \
  twinproduction/gatus:latest
```

## Additional Notes / Gotchas

Nothing specific to this stack so far.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: Gatus
Compose file path: gatus/compose.yaml
Additional env file (optional): gatus/sample.env

Then "Load" gatus/sample.env into the Environmental variables in dockhand, then modify.

Create the Stack
