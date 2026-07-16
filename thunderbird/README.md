# Thunderbird

## Overview

Access the application's full graphical interface directly from any modern web browser - no downloads, installs, or setup required on the client side - or connect with any VNC client.

The web interface also offers audio playback, seamless clipboard sharing, an integrated file manager and terminal for accessing the container's files and shell, desktop notifications, and more.

## Project Details

-   **Project Repository:** [Link](https://github.com/jlesage/docker-thunderbird)
-   **Container Image:** [Docker Hub](https://hub.docker.com/r/jlesage/thunderbird)
-   **Reverse Proxy Port:** `5800`

## Getting Started

1. Start the container: `docker compose up -d`
2. Open http://localhost:5800 in your browser
3. Follow the initial setup wizard to configure the application

## Environment Variable Notes

THUNDERBIRD_IMAGE=jlesage/thunderbird:latest

Used for securing online:
```
THUNDERBIRD_WEB_AUTHENTICATION=1
THUNDERBIRD_WEB_AUTHENTICATION_USERNAME=user
THUNDERBIRD_WEB_AUTHENTICATION_PASSWORD=password
THUNDERBIRD_SECURE_CONNECTION=1
```

## Volume Notes

I use the import/export plugin for thunderbird so I've added an optional volume:
```thunderbird-export:/export```

## Network Notes

Requires proxy network

## Docker Run

```bash
docker run -d \
  --name thunderbird \
  -p 5800:5800 \
  -v /data/thunderbird/config:/config \
  -v /data/thunderbird/export:/export \
  jlesage/thunderbird
```

See compose.yaml for the full set of environment variables.

## Additional Notes / Gotchas

GUI app streamed to the browser — unauthenticated by default aside from the web password, keep it behind the proxy.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: NAME_HERE
Compose file path: thunderbird/compose.yaml
Additional env file (optional): thunderbird/sample.env

Then "Load" thunderbird/sample.env into the Environmental variables in dockhand

Create the Stack
