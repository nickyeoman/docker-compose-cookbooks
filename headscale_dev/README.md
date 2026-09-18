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

Then point Nginx Proxy Manager at the `headscale` container, port `8080` (see Network Notes below) so `https://headscale.example.com` reaches it. Verify with:

```bash
curl https://headscale.example.com/health
```

### 2. Configure Nginx Proxy Manager

Add a proxy host in NPM for your headscale domain:

* **Details tab:**
  * Domain Names: `headscale.example.com`
  * Scheme: `http`, Forward Hostname/IP: `headscale`, Forward Port: `8080`
  * Enable: **Websockets Support**, Block Common Exploits
* **SSL tab:**
  * Request a new Let's Encrypt certificate, force SSL
  * **Disable "HTTP/2 Support"** — this is important and easy to miss. Tailscale clients register through a "noise" control protocol (`/ts2021`) that needs an ALPN/websocket upgrade; forcing HTTP/2 on this host can silently break that handshake even though normal HTTPS requests (like `/health`) still work fine. Symptoms if you skip this: `tailscale up` hangs indefinitely, headscale logs `no upgrade header in TS2021 request`, and `/ts2021` requests return `status=500`.
* Do **not** disable caching/buffering unless you also see stalled long-poll connections — the important toggles here are Websockets Support (on) and HTTP/2 Support (off).

Optional second proxy host for the admin UI — see [Network Notes](#network-notes) below.

### 3. Create a user and a pre-auth key

```bash
docker exec -it headscale-headscale-1 headscale -c /etc/headscale/config.yaml user create homelab
docker exec -it headscale-headscale-1 headscale users list
docker exec -it headscale-headscale-1 headscale preauthkeys create --user 1 --expiration 1h
```

Copy the key it prints — you'll use it once on each device you join.

> **Note on `--expiration`:** this only limits the window in which the key can be used to *register a new device*. Once a device has joined the tailnet with it, that device stays authorized regardless of the key's expiration — it doesn't get disconnected when the key expires. Register your device(s) within the window, or use a longer expiration (e.g. `24h`) / `--reusable` if you're onboarding multiple devices.

### 4. Connect the LAN node (the Docker host running Jellyfin)

On the **LAN node**, install the Tailscale client and point it at your Headscale server:

**Debian/Ubuntu:**
```bash
curl -fsSL https://tailscale.com/install.sh | sh
sudo systemctl enable --now tailscaled
```

**Arch:**
```bash
sudo pacman -S tailscale
sudo systemctl enable --now tailscaled
```

Then on any distro:
```bash
sudo tailscale up --login-server=https://headscale.example.com --authkey <YOUR-PREAUTH-KEY>
```

### 5. Connect your phone / laptop

#### Android / iOS

1. Install the Tailscale app (Play Store / App Store).
2. **Android (tested on v1.102.3, Galaxy S25 Ultra):** go to **Settings → Add account**, then tap the **three-dot menu (⋮)** that appears there and choose the alternate/custom coordination server option. Enter `https://headscale.example.com`.
   **iOS:** on the sign-in screen, look for **Alternate coordination server** before logging in.
3. Log in. If the app shows a registration URL/code instead of accepting a pre-auth key directly, approve it from the dedicated server:
   ```bash
   docker exec -it headscale-headscale-1 headscale nodes register --user homelab --key <KEY-FROM-DEVICE>
   ```

#### Laptop / desktop

Install the Tailscale client (https://tailscale.com/download), then run the same style of command used for the LAN node in step 4:

```bash
sudo tailscale up --login-server=https://headscale.example.com --authkey <YOUR-PREAUTH-KEY>
```

Or, if you'd rather approve interactively instead of using a pre-auth key:

```bash
sudo tailscale up --login-server=https://headscale.example.com
# copy the printed URL/key, then on the dedicated server:
docker exec -it headscale-headscale-1 headscale nodes register --user homelab --key <KEY-FROM-DEVICE>
```

### 6. Verify connectivity

```bash
docker exec -it headscale-headscale-1 headscale nodes list   # on the dedicated server
tailscale status                                     # on any client
tailscale ping <lan-node-hostname-or-100.64.x.x-ip>  # from your laptop/phone terminal
```

A reply that says `pong via ...` (direct or DERP) means the mesh works.

> **Troubleshooting: `tailscale up` hangs or fails with a 500 on `/ts2021`**
>
> This almost always means the reverse proxy isn't configured correctly — see the NPM settings in [step 2](#2-configure-nginx-proxy-manager) (Websockets Support on, HTTP/2 Support off). To confirm: watch `journalctl -u tailscaled -f` on the client and `docker logs ny-headscale-headscale-1` (or your container name) on the server while retrying `tailscale up`. The `/ts2021` requests should return `status=200`, not `500`.

### 7. Open Jellyfin

From your phone/laptop (with Tailscale connected), browse to:

* `http://<lan-node-tailscale-ip>:8096` (the 100.64.x.x address from `tailscale status`), or
* `http://<lan-node-hostname>.tailnet.local:8096` via MagicDNS (base domain set in `config.yaml`)

Jellyfin's port 8096 only needs to be reachable on the LAN node itself — never forward it on your router.

### 8. Set up the headscale-ui admin panel

The stack already runs `headscale-ui` (goodieshq/headscale-admin) alongside `headscale`. It's a browser app that talks to headscale's API directly using an API key.

**Serve it same-origin, on a subpath of your headscale domain — not a separate subdomain.** The app is a SvelteKit build with its asset base path hardcoded at build time to `/admin` (its files live at `/app/admin` inside the image), and if it's on a different origin than the headscale API, the browser blocks the API calls via CORS — headscale doesn't send `Access-Control-Allow-Origin` headers, and there's no supported way to add them via NPM without risking breaking the whole proxy host (ask if you're curious what happened when we tried). Serving both from the same domain sidesteps CORS entirely and matches how the app expects to be deployed.

1. **Add a Custom Location on the *existing* `headscale.example.com` proxy host in NPM** (don't create a separate proxy host/subdomain for this):
   * Location: `/admin`
   * Scheme: `http`, Forward Hostname/IP: `headscale-ui`, Forward Port: `80`
2. **Generate an API key:**
   ```bash
   docker exec -it headscale-headscale-1 headscale apikeys create --expiration 90d
   ```
   Copy the printed key — headscale won't show it again.
3. **Open the UI** at `https://headscale.example.com/admin/` and enter:
   * **Server URL:** `https://headscale.example.com` (same origin as the page you're on)
   * **API Key:** the key from step 2
4. You should now see users, nodes, and pre-auth keys manageable from the browser.

Re-run step 2 to mint a fresh key before the old one expires (`headscale apikeys list` / `headscale apikeys expire` to manage existing keys).

> **Note:** the server URL + API key are saved in that browser's `localStorage`, per browser/device — logging in from a different computer or browser just needs the *same* credentials entered again, not a new key. Only generate a new key if the old one actually expires or you've revoked it.

### Optional: subnet routing (reach other LAN devices)

If you want your tailnet devices to reach *everything* on the LAN (not just the LAN node), advertise the subnet from the LAN node:

```bash
sudo tailscale up --login-server=https://headscale.example.com --advertise-routes=192.168.1.0/24
# then approve the route on the dedicated server:
docker exec -it headscale-headscale-1 headscale nodes list-routes
docker exec -it headscale-headscale-1 headscale nodes approve-routes -i <NODE-ID> --routes 192.168.1.0/24
```

Also enable IP forwarding on the LAN node:

```bash
echo 'net.ipv4.ip_forward = 1' | sudo tee /etc/sysctl.d/99-tailscale.conf
sudo sysctl -p /etc/sysctl.d/99-tailscale.conf
```

### Revoking a compromised device

```bash
docker exec -it headscale-headscale-1 headscale nodes list
docker exec -it headscale-headscale-1 headscale nodes delete -i <NODE-ID>
docker exec -it headscale-headscale-1 headscale preauthkeys expire --user homelab <KEY>   # if the key leaked too
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
* `headscale-ui` admin panel: add a **Custom Location** (`/admin`) on the *same* `headscale.example.com` proxy host — not a separate subdomain, which triggers CORS failures against the headscale API. See [step 8](#8-set-up-the-headscale-ui-admin-panel) for the full setup including the API key:
  * Location: `/admin`, forward hostname: `headscale-ui`, forward port: `80`, scheme: `http`
  * `HEADSCALE_URL=http://headscale:8080` (see compose.yaml) only prefills the internal address in the UI — you still authenticate the browser session yourself with an API key (step 8)

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
