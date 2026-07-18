# Glance

## Overview

Glance is a self-hosted, fast-loading dashboard that pulls together bookmarks, RSS feeds, weather, service monitors, and more onto a single customizable page, configured entirely through one YAML file.

## Project Details

* Project Repository: https://github.com/glanceapp/glance
* Container Image: https://hub.docker.com/r/glanceapp/glance
* Documentation: https://github.com/glanceapp/glance/blob/main/docs/configuration.md
* Reverse Proxy Domain: glance.example.com
* Reverse Proxy Port: `8080`

## Getting Started

1. Copy the starter config into place, then edit it:
   ```bash
   mkdir -p /data/glance/config
   cp config/glance.yml /data/glance/config/glance.yml
   nano /data/glance/config/glance.yml   # add your own pages, widgets, and links
   ```
2. Copy env defaults: `cp sample.env .env`
3. Start the stack: `docker compose up -d`
4. Open `http://localhost:8080` (or your reverse proxy domain) in your browser

## Environment Variable Notes

```
GLANCE_IMAGE – Docker image for Glance (default: glanceapp/glance:latest)
GLANCE_RESTART – Restart policy (default: unless-stopped)
GLANCE_PORT – Host port to publish (default: 8080)

VOL_PATH – Base path for config volume (default: /data)
TZ – Timezone (default: America/Vancouver)
```

## Volume Notes

```
${VOL_PATH}/glance/config – glance.yml (required, see config/glance.yml starter) and any assets it references
```

Glance hot-reloads `glance.yml` on change, so config edits don't require a container restart.

## Network Notes

* Uses the external `proxy` network only — Glance is a single lightweight container with no backing database
* Widgets that monitor other services (e.g. `monitor`) reach them by container name if those services share the `proxy` network, or by LAN address otherwise

## Docker Run

```bash
docker run -d \
  --name=glance \
  -v /data/glance/config:/app/config \
  -p 8080:8080 \
  glanceapp/glance:latest
```

## Additional Notes / Gotchas

* All configuration lives in `glance.yml` — there is no setup wizard or admin UI
* The starter config includes example `clock`, `bookmarks`, `weather`, `monitor`, `rss`, and `server-stats` widgets; remove or replace what you don't need
* The `monitor` widget checks HTTP status only — it doesn't require the target service to expose any special metrics endpoint
* See the [widgets reference](https://github.com/glanceapp/glance/blob/main/docs/configuration.md#widgets) for the full list of available widget types

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: glance_dev
Compose file path: glance_dev/compose.yaml
Additional env file (optional): glance_dev/sample.env

Then "Load" glance_dev/sample.env into the Environmental variables in dockhand.

Ensure `glance.yml` exists at `${VOL_PATH}/glance/config/glance.yml` before deploying.

Create the Stack.
