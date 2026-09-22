# Firefox

## Overview

Access the application's full graphical interface directly from any modern web browser - no downloads, installs, or setup required on the client side - or connect with any VNC client.

The web interface also offers audio playback, seamless clipboard sharing, an integrated file manager and terminal for accessing the container's files and shell, desktop notifications, and more.

## Project Details

-   **Project Repository:** [Link](https://github.com/jlesage/docker-firefox)
-   **Container Image:** [Docker Hub](https://hub.docker.com/r/jlesage/firefox)
-   **Reverse Proxy Port:** `5800`

## Getting Started

1. Start the container: `docker compose up -d`
2. Open http://localhost:5800 in your browser
3. Follow the initial setup wizard to configure the application

## Environment Variable Notes

FIREFOX_IMAGE=jlesage/firefox:latest

Used for securing online:
```
FIREFOX_WEB_AUTHENTICATION=1
FIREFOX_WEB_AUTHENTICATION_USERNAME=user
FIREFOX_WEB_AUTHENTICATION_PASSWORD=password
FIREFOX_SECURE_CONNECTION=1
```

## Network Notes

Requires proxy network

## Docker Run

```bash
docker run -d \
  --name firefox \
  -p 5800:5800 \
  -v /data/firefox/config:/config \
  jlesage/firefox
```

See compose.yaml for the full set of environment variables.

## Additional Notes / Gotchas

GUI app streamed to the browser — unauthenticated by default aside from the web password, keep it behind the proxy.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: NAME_HERE
Compose file path: firefox/compose.yaml
Additional env file (optional): firefox/sample.env

Then "Load" firefox/sample.env into the Environmental variables in dockhand

Create the Stack
