# Ntfy

## Overview

Ntfy (pronounced "notify") is a simple HTTP-based pub-sub notification service. With ntfy, you can send notifications to your phone or desktop via scripts from any computer, without having to sign up or pay any fees.

## Project Details

-   **Project Repository:** https://github.com/binwiederhier/ntfy
-   **Container Image:** [Docker Hub](https://hub.docker.com/r/binwiederhier/ntfy)
-   **Compose Example:** [Ntfy Docker Compose](https://github.com/binwiederhier/ntfy/blob/main/docker-compose.yml)
-   **Documentation:** [Ntfy Docs](https://github.com/binwiederhier/ntfy#user-content-ntfy)
-   **Reverse Proxy Port:** `80`

## Getting Started

1. Start the container: `docker compose up -d`
2. Access ntfy: `http://localhost:80` or `http://localhost:8080`
3. Configure your notification topics via the web interface

## Environment Variable Notes

-   `NTFY_IMAGE` – Docker image to use (default: `binwiederhier/ntfy`)
-   `NTFY_PORT` – HTTP port to expose (default: `80`)
-   `NTFY_HTTP_PORT` – Internal HTTP port (default: `8080`)
-   `NTFY_RESTART` – Restart policy (default: `unless-stopped`)
-   `TZ` – Timezone for container (default: `UTC`)
-   `NTFY_BASE_URL` – Base URL for ntfy instance (default: `http://localhost`)
-   `NTFY_CACHE_FILE` – SQLite cache file path (default: `/var/lib/ntfy/cache.db`)
-   `NTFY_AUTH_FILE` – SQLite auth file path (default: `/var/lib/ntfy/auth.db`)
-   `NTFY_AUTH_DEFAULT_ACCESS` – Auth policy (default: `deny-all`)
-   `NTFY_BEHIND_PROXY` – Run behind reverse proxy (default: `true`)
-   `NTFY_ATTACHMENT_CACHE_DIR` – Attachment cache directory (default: `/var/lib/ntfy/attachments`)
-   `NTFY_ENABLE_LOGIN` – Enable user login (default: `true`)

## Volume Notes

-   `/data` – Persistent storage for ntfy configuration, authentication, and cache files

## Network Notes

Requires proxy network

## Docker Run

```bash
docker run -d \
  --name ntfy \
  -e NTFY_IMAGE=binwiederhier/ntfy \
  -e NTFY_PORT=80 \
  -e NTFY_HTTP_PORT=8080 \
  -e NTFY_RESTART=unless-stopped \
  -e TZ=UTC \
  -e NTFY_BASE_URL=http://localhost \
  -e NTFY_CACHE_FILE=/var/lib/ntfy/cache.db \
  -e NTFY_AUTH_FILE=/var/lib/ntfy/auth.db \
  -e NTFY_AUTH_DEFAULT_ACCESS=deny-all \
  -e NTFY_BEHIND_PROXY=true \
  -e NTFY_ATTACHMENT_CACHE_DIR=/var/lib/ntfy/attachments \
  -e NTFY_ENABLE_LOGIN=true \
  -v /data/ntfy:/etc/ntfy \
  -v /data/ntfy-var:/var/lib/ntfy \
  -v /data/ntfy-cache:/var/cache/ntfy \
  -p 80:80 \
  -p 8080:8080 \
  binwiederhier/ntfy
```

## Additional Notes / Gotchas

-   Requires SQLite database for cache and authentication
-   Authentication is enabled by default; you need to create users via the web interface
-   Static attachments are cached in `/var/lib/ntfy/attachments`
-   The service supports both HTTP and WebSocket connections
-   Configure TLS/SSL with a reverse proxy like Nginx for production use
-   Use the REST API to send notifications: `curl -X PUT http://localhost:80/TOPIC_NAME -d 'Notification message'`

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: ntfy
Compose file path: ntfy_dev/compose.yaml
Additional env file (optional): ntfy_dev/sample.env

Then "Load" ntfy_dev/sample.env into the Environmental variables in dockhand

Create the Stack
