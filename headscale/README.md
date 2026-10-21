# Headscale

## Overview

Self-hosted Tailscale control server. Reach homelab services (Jellyfin, Ollama, n8n, etc.) on a LAN node from your phone or laptop, anywhere — **without exposing them to the internet**.

```
[Phone / Laptop] → Tailscale client
        |
[Dedicated Server]  ← public IP, runs Headscale (this stack) behind NPM
        |
   WireGuard mesh (peer-to-peer when possible)
        |
[LAN Node]          ← Docker host on 192.168.x.x, joins as a Tailscale client
```

The dedicated server is **only the control plane** — traffic flows directly between devices whenever possible.

## Project Details

* Project Repository: https://github.com/juanfont/headscale
* Container Image: https://hub.docker.com/r/headscale/headscale
* Admin UI Image: https://hub.docker.com/r/goodieshq/headscale-admin
* Documentation: https://headscale.net/
* Reverse Proxy Domain: headscale.example.com
* Internal Service Port: 8080 (not exposed publicly)

## Getting Started

Follow in order — each step has its own guide in [`docs/`](docs/):

| Step | Task | Where |
|---|---|---|
| 1 | [Install Headscale](docs/install.md) | Dedicated server |
| 2 | [Configure Nginx Proxy Manager](docs/nginx-proxy-manager.md) — **HTTP/2 off, Websockets on** | NPM |
| 3 | [Create a user and pre-auth key](docs/users-and-keys.md) | Dedicated server |
| 4 | [Connect the LAN node](docs/connect-lan-node.md) | LAN node |
| 5 | [Connect phone / laptop](docs/connect-clients.md) | Clients |
| 6 | [Verify and troubleshoot](docs/verify-and-troubleshoot.md) | Anywhere |
| 7 | [Access LAN services (Jellyfin)](docs/access-services.md) | Clients |
| 8 | [Admin UI](docs/admin-ui.md) | NPM + browser |

Optional / maintenance:

* [Subnet routing](docs/subnet-routing.md) — reach every LAN device, not just the node
* [Revoke a compromised device](docs/revoke-device.md)

### Quick commands

```bash
# Set the headscale container name once per shell (server; change if your compose project name differs — check with `docker ps`)
export HEADSCALE_CONTAINER=headscale-headscale-1

# List all registered devices (server)
docker exec -it "$HEADSCALE_CONTAINER" headscale nodes list

# Create a one-hour pre-auth key for user ID 1 to join a new device (server)
docker exec -it "$HEADSCALE_CONTAINER" headscale preauthkeys create --user 1 --expiration 1h

# Create a 90-day API key for the admin UI (server)
docker exec -it "$HEADSCALE_CONTAINER" headscale apikeys create --expiration 90d

# Join this machine to the tailnet using a pre-auth key (client)
sudo tailscale up --login-server=https://headscale.example.com --authkey <KEY>
```

## Environment Variable Notes

```
HEADSCALE_IMAGE – Headscale image (default: headscale/headscale:latest)
HEADSCALE_UI_IMAGE – Admin UI image (default: goodieshq/headscale-admin:latest)
HEADSCALE_RESTART / HEADSCALE_UI_RESTART – Restart policy (default: unless-stopped)
VOL_PATH – Base path for volumes (default: /data)
TZ – Timezone (default: America/Vancouver)
HEADSCALE_LOG_LEVEL – info, debug, etc.

# Documented for config.yaml (not read by compose):
HEADSCALE_DOMAIN – Public domain (e.g. headscale.example.com)
HEADSCALE_URL – Full client URL; must match server_url in config.yaml
```

## Volume Notes

```
${VOL_PATH}/headscale/config → config.yaml (required before first start)
${VOL_PATH}/headscale/data   → SQLite database and state
${VOL_PATH}/headscale/logs   → Logs
```

Back up `config/` and `data/` regularly.

## Network Notes

* External `proxy` network plus private `internal` bridge
* No published ports — all access via NPM
* `headscale` → NPM proxy host, `http://headscale:8080` (see [NPM guide](docs/nginx-proxy-manager.md))
* `headscale-ui` → Custom Location `/admin` on the **same** proxy host, `http://headscale-ui:80` (a separate subdomain breaks via CORS — see [Admin UI](docs/admin-ui.md))
* Firewall: dedicated server only needs 80/443 inbound; LAN node should allow UDP 41641 for direct WireGuard
* Never forward 8080 (Headscale) or 8096 (Jellyfin) on any router

## Docker Run

```bash
docker run -d \
  --name headscale \
  -v /data/headscale/config:/etc/headscale \
  -v /data/headscale/data:/var/lib/headscale \
  -v /data/headscale/logs:/var/log/headscale \
  headscale/headscale:latest \
  serve
```

## Additional Notes / Gotchas

* No valid `config.yaml` → Headscale won't start; `server_url` **must** match your public domain
* NPM **HTTP/2 Support must be off** or `tailscale up` hangs (`/ts2021` returns 500)
* Pre-auth key expiration only limits new registrations — joined devices stay connected
* SQLite by default (no external DB)
* MagicDNS base domain is `tailnet.local`; change it in `config.yaml` if it clashes with your LAN DNS

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: headscale
Compose file path: headscale/compose.yaml
Additional env file (optional): headscale/sample.env

Then "Load" headscale/sample.env into the Environmental variables in dockhand.

Ensure `config.yaml` exists at `${VOL_PATH}/headscale/config/config.yaml` before deploying.

Create the Stack, then configure the reverse proxy in Nginx Proxy Manager.
