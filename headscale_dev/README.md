# Heascale

## Overview

Headscale is a self-hosted control server for Tailscale clients. It allows you to run your own private coordination plane for a WireGuard-based mesh network without relying on external SaaS services.

This deployment is designed to run fully self-hosted behind a reverse proxy.

Requires a valid config.yaml before first startup.

## Project Details

* Project Repository: https://github.com/juanfont/headscale
* Container Image: https://hub.docker.com/r/headscale/headscale
* Admin UI Image: https://hub.docker.com/r/goodieshq/headscale-admin
* Documentation: https://headscale.net/
* Reverse Proxy Domain: headscale.example.com
* Internal Service Port: 8080 (not exposed publicly)
* Environment Variable Notes

## Getting Started

1. Start the container: `docker compose up -d`
2. Open http://localhost:PORT in your browser
3. Follow the initial setup wizard to configure the application

## Environment Variable Notes

    HEADSCALE_LOG_LEVEL – default: info

## Volume Notes

All data is stored locally on the host for full self-sovereignty:

```
./config/headscale/config → Contains config.yaml (required configuration file)
./data/headscale → SQLite database and persistent Headscale state
./logs/headscale → Optional logs for debugging and monitoring
```

Back up data/ and config/ regularly for recovery.

## Network Notes

Uses a private Docker bridge network: internal
No public ports exposed directly
All access is routed through reverse proxy (NPM)
Reverse Proxy Requirements (Nginx Proxy Manager)

For headscale.example:

Forward hostname: headscale
Forward port: 8080
Scheme: http
Enable:
Websockets Support ✔
Block Common Exploits ✔
SSL (Let’s Encrypt) ✔
Disable caching ✔
Additional Notes / Gotchas
Headscale will not function without a valid config.yaml

server_url inside config.yaml MUST match your domain.

Clients must explicitly point to your server:

tailscale up --login-server=https://headscale.4lt.ca
Do NOT expose port 8080 publicly — only via reverse proxy
SQLite is used by default (no external DB required)
Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: headscale

Compose file path:

headscale/compose.yaml

Additional env file (optional):

headscale/sample.env
Deployment Steps
Load sample.env into Dockhand environment variables

Ensure config.yaml exists in:

./config/headscale/config/config.yaml
Deploy stack
Configure reverse proxy in Nginx Proxy Manager

## Docker Run

```bash
docker run -d \
  --name headscale \
  -v /data/headscale/config:/etc/headscale \
  -v /data/headscale/data:/var/lib/headscale \
  -v /data/headscale/logs:/var/log/headscale \
  headscale/headscale:latest
```

See compose.yaml for the full set of environment variables.

## Additional Notes / Gotchas

Nothing specific to this stack so far.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: headscale_dev
Compose file path: headscale_dev/compose.yaml
Additional env file (optional): headscale_dev/sample.env

Then "Load" headscale_dev/sample.env into the Environmental variables in dockhand

Create the Stack

## Core Settings

These variables are used in the Docker Compose file (.env):

```
HEADSCALE_IMAGE – Docker image for Headscale server (default: headscale/headscale:latest)
HEADSCALE_UI_IMAGE – Docker image for admin UI
HEADSCALE_RESTART – Restart policy (default: unless-stopped)
HEADSCALE_UI_RESTART – Restart policy for UI container

# Paths
CONFIG_PATH – Location of configuration files (config.yaml)
DATA_PATH – Persistent database storage (SQLite)
LOG_PATH – Application logs

# System
TZ – Timezone (e.g. America/Vancouver)
HEADSCALE_LOG_LEVEL – Logging verbosity (info, debug, etc.)
Domain Configuration
HEADSCALE_DOMAIN – Public-facing domain used via reverse proxy
Example: headscale.4lt.ca

HEADSCALE_URL – Full URL used by Headscale clients
Must match your reverse proxy domain:
```
