# Pangolin

## Overview

Pangolin is a self-hosted tunneled reverse proxy with identity-aware access control. It exposes services running behind NAT or on a private LAN to the internet without port-forwarding, using its own WireGuard tunnel (`gerbil`) and a bundled Traefik instance for TLS termination and routing.

Unlike most stacks in this repo, Pangolin **is itself the edge reverse proxy** — it does not sit behind Nginx Proxy Manager. It needs its own public IP and listens directly on ports 80/443/51820.

## Project Details

* Project Repository: https://github.com/fosrl/pangolin
* Container Image: https://hub.docker.com/r/fosrl/pangolin
* Compose Example: https://github.com/fosrl/pangolin/blob/main/docker-compose.example.yml
* Documentation: https://docs.fossorial.io/
* Reverse Proxy Domain: pangolin.example.com
* Internal Service Port: 3000 (API), 3001 (internal API), 3002 (dashboard/next)

## Getting Started

1. Copy the starter config into place and edit it:
   ```bash
   mkdir -p /data/pangolin/config /data/pangolin/traefik /data/pangolin/letsencrypt /data/pangolin/gerbil
   cp config/config.yml /data/pangolin/config/config.yml
   cp config/traefik/traefik_config.yml config/traefik/dynamic_config.yml /data/pangolin/traefik/
   nano /data/pangolin/config/config.yml   # set dashboard_url, base_domain, secret, admin email/password
   nano /data/pangolin/traefik/*.yml       # replace pangolin.example.com with your real domain
   ```
2. Copy env defaults: `cp sample.env .env`
3. Start the stack: `docker compose up -d`
4. Open `https://pangolin.example.com` and log in with the admin user set in `config.yml`
5. Follow the in-app wizard to create a site (installs a `newt` client on the machine you want to expose) and add resources

## Environment Variable Notes

```
PANGOLIN_IMAGE – Docker image for the Pangolin server (default: fosrl/pangolin:latest)
PANGOLIN_RESTART – Restart policy

GERBIL_IMAGE – Docker image for the gerbil WireGuard gateway (default: fosrl/gerbil:latest)
GERBIL_RESTART – Restart policy
GERBIL_WG_PORT – UDP port for the WireGuard tunnel (default: 51820)
GERBIL_HTTP_PORT – Public HTTP port, proxied through gerbil to traefik (default: 80)
GERBIL_HTTPS_PORT – Public HTTPS port, proxied through gerbil to traefik (default: 443)

TRAEFIK_IMAGE – Docker image for Traefik (default: traefik:v3.3)
TRAEFIK_RESTART – Restart policy

VOL_PATH – Base path for config/data volumes (default: /data)
TZ – Timezone (default: America/Vancouver)
```

## Volume Notes

```
${VOL_PATH}/pangolin/config       – config.yml (required, see config/config.yml starter)
${VOL_PATH}/pangolin/gerbil       – gerbil's generated WireGuard key/state
${VOL_PATH}/pangolin/traefik      – traefik_config.yml and dynamic_config.yml (required, see config/traefik/)
${VOL_PATH}/pangolin/letsencrypt  – ACME certificate storage (acme.json)
```

## Network Notes

* **Does not sit behind NPM like other stacks in this repo** — Pangolin is its own edge reverse proxy. The `proxy` network is declared for convention but none of its services actually join it (see AGENTS.md "Known exceptions").
* `traefik` runs with `network_mode: service:gerbil`, sharing gerbil's network namespace so it can bind the ports gerbil forwards from the WireGuard tunnel.
* Only `gerbil` publishes ports to the host: `51820/udp` (WireGuard), `80/tcp`, `443/tcp`.
* Requires a public IP with 80/443/51820 open inbound (or forwarded, if behind NAT). This is a different deployment model than the LAN-only, NPM-fronted stacks elsewhere in this repo.

## Docker Run

```bash
docker run -d \
  --name=pangolin \
  -v /data/pangolin/config:/app/config \
  fosrl/pangolin:latest
```

See compose.yaml for the full multi-container setup (`pangolin` + `gerbil` + `traefik`) — Pangolin does not function correctly as a single container.

## Additional Notes / Gotchas

* All three services (`pangolin`, `gerbil`, `traefik`) must run together; gerbil needs `NET_ADMIN` and `SYS_MODULE` capabilities for WireGuard.
* `dashboard_url`, `base_domain`, and the `pangolin.example.com` references in the Traefik dynamic config must all be updated to match your real domain before first start.
* Change `secret` and the admin `password` in `config.yml` before exposing this publicly — the repo default of `ChangeThisPassword` is not safe to leave in place, since this stack is internet-facing by design.
* After a site is registered in the dashboard, exposed services are reached by installing the lightweight `newt` client on the target host — see the Pangolin docs for `newt` setup.
* Certificates are issued automatically via Traefik's ACME HTTP challenge on port 80; keep port 80 open even if you only care about HTTPS.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: pangolin_dev
Compose file path: pangolin_dev/compose.yaml
Additional env file (optional): pangolin_dev/sample.env

Then "Load" pangolin_dev/sample.env into the Environmental variables in dockhand.

Ensure `config.yml`, `traefik_config.yml`, and `dynamic_config.yml` exist under `${VOL_PATH}/pangolin/` before deploying.

Create the Stack.
