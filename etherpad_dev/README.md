# Etherpad

## Overview

Etherpad is a highly customizable open source online editor providing collaborative editing in real-time. It's perfect for collaborative work sessions, note-taking, and document creation.

## Project Details

-   **Project Repository:** https://github.com/etherpad/etherpad-lite
-   **Container Image:** [Docker Hub](https://hub.docker.com/_/node)
-   **Compose Example:** [Etherpad Docker Compose](https://github.com/etherpad/etherpad-lite/blob/master/docker-compose.yml)
-   **Documentation:** [Etherpad Docs](https://etherpad.org/documentation/)
-   **Reverse Proxy Port:** `9001`

## Getting Started

1. Start the container: `docker compose up -d`
2. Access Etherpad: `http://localhost:9001`
3. Log in with admin/etherpad (default credentials)

## Environment Variable Notes

-   `ETHERPAD_IMAGE` – Docker image to use (default: `node:18-slim`)
-   `ETHERPAD_PORT` – Port to expose (default: `9001`)
-   `ETHERPAD_RESTART` – Restart policy (default: `unless-stopped`)
-   `TZ` – Timezone for container (default: `UTC`)
-   `ETHERPAD_DEFAULT_TITLE` – Default title for new pads (default: `Etherpad`)
-   `ETHERPAD_DEFAULT_TEXT` – Default welcome text for new pads (default: `Welcome to Etherpad!`)
-   `ETHERPAD_ADMIN_PASSWORD` – Admin password for authentication (default: `admin`)

## Volume Notes

-   `/data` – Persistent storage for Etherpad configuration and data files

## Network Notes

Requires proxy network

## Docker Run

```bash
docker run -d \
  --name etherpad \
  -e ETHERPAD_IMAGE=node:18-slim \
  -e ETHERPAD_PORT=9001 \
  -e ETHERPAD_RESTART=unless-stopped \
  -e TZ=UTC \
  -e ETHERPAD_DEFAULT_TITLE=Etherpad \
  -e ETHERPAD_DEFAULT_TEXT=Welcome to Etherpad! \
  -e ETHERPAD_ADMIN_PASSWORD=admin \
  -v /data/etherpad:/home/etherpad \
  -p 9001:9001 \
  node:18-slim
```

## Additional Notes / Gotchas

-   Etherpad requires curl and git to be installed in the container for initial setup
-   After container starts, you can access the WebSocket port at 9001 for real-time collaboration
-   Change the admin password immediately after first login
-   The docker image installs Etherpad from GitHub source

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: etherpad
Compose file path: etherpad_dev/compose.yaml
Additional env file (optional): etherpad_dev/sample.env

Then "Load" etherpad_dev/sample.env into the Environmental variables in dockhand

Create the Stack
