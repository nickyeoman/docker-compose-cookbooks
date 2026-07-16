# Headscale

## Overview

Headscale is a self-hosted control server for Tailscale clients. It lets you run your own private coordination plane for a WireGuard-based mesh network without relying on Tailscale's SaaS.

The homelab use case this stack is built for: securely reach services (Jellyfin, Ollama, n8n, etc.) running in Docker on a LAN node — from your phone or laptop, anywhere — **without exposing those services to the internet**.

```
[Phone / Laptop]
        |
   Tailscale client
        |
[Dedicated Server]  ← public IP, runs Headscale (this stack) behind a reverse proxy
        |
   Tailscale network (WireGuard mesh)
        |
[LAN Node]          ← Docker host on 192.168.x.x, runs Jellyfin etc., joins as a Tailscale client
```

The dedicated server acts **only as the control plane** — media traffic flows directly (peer-to-peer over WireGuard) between your device and the LAN node whenever possible. See `index.html` for a 15-minute quick-start checklist, and the walkthrough below for full details.

Requires a valid `config.yaml` before first startup (a starter is included in this directory).

## Project Details

* Project Repository: https://github.com/juanfont/headscale
* Container Image: https://hub.docker.com/r/headscale/headscale
* Admin UI Image: https://hub.docker.com/r/goodieshq/headscale-admin
* Documentation: https://headscale.net/
* Reverse Proxy Domain: headscale.example.com
* Internal Service Port: 8080 (not exposed publicly)

## Getting Started

All commands below run on the **dedicated server** unless noted otherwise.

### 1. Install Headscale on the dedicated server (this repo)

```bash
# Copy the starter config into place, then edit it
mkdir -p /data/headscale/config
cp config.yaml /data/headscale/config/config.yaml
nano /data/headscale/config/config.yaml   # set server_url to YOUR domain, e.g. https://headscale.example.com

# Copy env defaults and start the stack
cp sample.env .env
docker compose up -d
```

Then point Nginx Proxy Manager at it (see Network Notes below) so `https://headscale.example.com` reaches the container. Verify with:

```bash
curl https://headscale.example.com/health
```

### 2. Create a user and a pre-auth key

```bash
docker compose exec headscale headscale users create homelab
docker compose exec headscale headscale preauthkeys create --user homelab --expiration 1h
```

Copy the key it prints — you'll use it once on each device you join.

### 3. Connect the LAN node (the Docker host running Jellyfin)

On the **LAN node**, install the Tailscale client and point it at your Headscale server:

```bash
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up --login-server=https://headscale.example.com --authkey <YOUR-PREAUTH-KEY>
```

(Arch users: `sudo pacman -S tailscale && sudo systemctl enable --now tailscaled`, then the same `tailscale up` command.)

### 4. Connect your phone / laptop

Install the Tailscale app (App Store / Play Store / https://tailscale.com/download). In the app, choose **Use a custom server / alternate coordination server** and enter `https://headscale.example.com`, or on desktop run the same `tailscale up --login-server=...` command. Generate a fresh pre-auth key per device, or approve interactively:

```bash
# if a device shows a registration URL instead of using a key:
docker compose exec headscale headscale nodes register --user homelab --key <KEY-FROM-DEVICE>
```

### 5. Verify connectivity

```bash
docker compose exec headscale headscale nodes list   # on the dedicated server
tailscale status                                     # on any client
tailscale ping <lan-node-hostname-or-100.64.x.x-ip>  # from your laptop/phone terminal
```

A reply that says `pong via ...` (direct or DERP) means the mesh works.

### 6. Open Jellyfin

From your phone/laptop (with Tailscale connected), browse to:

* `http://<lan-node-tailscale-ip>:8096` (the 100.64.x.x address from `tailscale status`), or
* `http://<lan-node-hostname>.tailnet.local:8096` via MagicDNS (base domain set in `config.yaml`)

Jellyfin's port 8096 only needs to be reachable on the LAN node itself — never forward it on your router.

### Optional: subnet routing (reach other LAN devices)

If you want your tailnet devices to reach *everything* on the LAN (not just the LAN node), advertise the subnet from the LAN node:

```bash
sudo tailscale up --login-server=https://headscale.example.com --advertise-routes=192.168.1.0/24
# then approve the route on the dedicated server:
docker compose exec headscale headscale nodes list-routes
docker compose exec headscale headscale nodes approve-routes -i <NODE-ID> --routes 192.168.1.0/24
```

Also enable IP forwarding on the LAN node:

```bash
echo 'net.ipv4.ip_forward = 1' | sudo tee /etc/sysctl.d/99-tailscale.conf
sudo sysctl -p /etc/sysctl.d/99-tailscale.conf
```

### Revoking a compromised device

```bash
docker compose exec headscale headscale nodes list
docker compose exec headscale headscale nodes delete -i <NODE-ID>
docker compose exec headscale headscale preauthkeys expire --user homelab <KEY>   # if the key leaked too
```

The device is cut off immediately; re-join it later with a fresh key if needed.

## Environment Variable Notes

These variables are used in the Docker Compose file (`.env`):

```
HEADSCALE_IMAGE – Docker image for Headscale server (default: headscale/headscale:latest)
HEADSCALE_UI_IMAGE – Docker image for admin UI
HEADSCALE_RESTART – Restart policy (default: unless-stopped)
HEADSCALE_UI_RESTART – Restart policy for UI container

# Paths
VOL_PATH – Base path for config/data/logs volumes (default: /data)

# System
TZ – Timezone (e.g. America/Vancouver)
HEADSCALE_LOG_LEVEL – Logging verbosity (info, debug, etc.)

# Documented for config.yaml (not read by compose):
HEADSCALE_DOMAIN – Public-facing domain used via reverse proxy (e.g. headscale.example.com)
HEADSCALE_URL – Full URL used by clients; must match server_url in config.yaml
```

## Volume Notes

All data is stored locally on the host for full self-sovereignty:

```
${VOL_PATH}/headscale/config → Contains config.yaml (required configuration file)
${VOL_PATH}/headscale/data   → SQLite database and persistent Headscale state
${VOL_PATH}/headscale/logs   → Optional logs for debugging and monitoring
```

Back up `data/` and `config/` regularly for recovery.

## Network Notes

* Uses the external `proxy` network plus a private bridge network `internal`
* No public ports exposed directly — all access is routed through the reverse proxy (NPM)
* Reverse proxy requirements (Nginx Proxy Manager), for `headscale.example.com`:
  * Forward hostname: `headscale`, forward port: `8080`, scheme: `http`
  * Enable: Websockets Support ✔, Block Common Exploits ✔, SSL (Let's Encrypt) ✔, disable caching ✔

Firewall considerations on the dedicated server: only 80/443 (reverse proxy) need to be open inbound. On the LAN node: allow UDP 41641 outbound/inbound for direct WireGuard connections (Tailscale falls back to DERP relays if blocked, just slower). Do **not** forward 8096 (Jellyfin) or 8080 (Headscale) on any router.

## Docker Run

```bash
docker run -d \
  --name headscale \
  -v /data/headscale/config:/etc/headscale \
  -v /data/headscale/data:/var/lib/headscale \
  -v /data/headscale/logs:/var/log/headscale \
  headscale/headscale:latest \
  headscale serve
```

See compose.yaml for the full set of environment variables.

## Additional Notes / Gotchas

* Headscale will not function without a valid `config.yaml`
* `server_url` inside `config.yaml` MUST match your public domain
* Clients must explicitly point to your server: `tailscale up --login-server=https://headscale.example.com`
* Do NOT expose port 8080 publicly — only via reverse proxy
* SQLite is used by default (no external DB required)
* MagicDNS base domain is `tailnet.local` (set in `config.yaml`); change it if it clashes with your LAN DNS

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: headscale_dev
Compose file path: headscale_dev/compose.yaml
Additional env file (optional): headscale_dev/sample.env

Then "Load" headscale_dev/sample.env into the Environmental variables in dockhand.

Ensure `config.yaml` exists at `${VOL_PATH}/headscale/config/config.yaml` before deploying.

Create the Stack, then configure the reverse proxy in Nginx Proxy Manager.
