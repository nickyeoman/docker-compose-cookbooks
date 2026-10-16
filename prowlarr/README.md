# Prowlarr

## Overview

Prowlarr is an indexer manager and proxy for the *arr ecosystem. It centralizes your torrent tracker and Usenet indexer configuration — add them once in Prowlarr and they sync automatically to Sonarr, Radarr, Lidarr, and Readarr. It's a modern replacement for Jackett with a unified API and built-in sync.

## Project Details

- **Project Repository:** [https://prowlarr.com/](https://prowlarr.com/)
- **Container Image:** [ghcr.io/hotio/prowlarr](https://hotio.dev/containers/prowlarr/)
- **Reverse Proxy Port:** `9696`

## Getting Started

Open http://localhost:9696 in your browser.

1. **Create the admin account** — on first boot Prowlarr shows an *Authentication Required* dialog. Set:
   - **Authentication Method:** `Forms (Login Page)`
   - **Authentication Required:** `Enabled` (or `Disabled for Local Addresses` if you trust your LAN)
   - **Username / Password:** your admin credentials

   Click **Save**. You'll be sent to the login page — sign in with the account you just created.
2. **Add an indexer** — go to **Indexers → Add Indexer** (the `+` button):
   1. Filter the list by **Protocol** (torrent / usenet), **Language**, or **Privacy** (public / semi-private / private), or type the tracker name into the search box
   2. Click the indexer to open its settings
   3. **Public trackers** (e.g. 1337x, The Pirate Bay, YTS) usually need no extra settings
   4. **Private trackers** need credentials from your account on that site — typically an **API key**, **passkey**, or **cookie / username + password** (the form tells you which field it needs; the tracker's profile/security page has the value)
   5. **Usenet indexers** (e.g. NZBgeek, DrunkenSlug) need the **API key** from your indexer account page. Usenet providers (the server you download from) are *not* added here — they go in SABnzbd/NZBGet
   6. Leave **Sync Profile** as `Standard` and **Tags** empty unless you need them
   7. Click **Test** — a green check means Prowlarr can reach and authenticate with the indexer — then **Save**

   Repeat for each indexer. If a tracker is behind Cloudflare and the test fails with a Cloudflare/challenge error, set up FlareSolverr (step 3) and tag that indexer with `flaresolverr`.
3. **Add FlareSolverr as an indexer proxy** — this stack runs a FlareSolverr container that solves Cloudflare challenges for Prowlarr. Go to **Settings → Indexers → `+` → FlareSolverr**:
   - **Name:** `FlareSolverr`
   - **Tags:** `flaresolverr` (only indexers with this tag are routed through it)
   - **Host:** `http://flaresolverr:8191/`
   - **Request Timeout:** `60`

   Click **Test**, then **Save**. Then edit each Cloudflare-protected indexer, add the `flaresolverr` tag, and **Test** again.
4. **Connect your *arr apps** — go to **Settings → Apps → `+`** and pick Sonarr, Radarr, Lidarr, etc.:
   - **Prowlarr Server:** how the *arr app reaches Prowlarr, e.g. `http://prowlarr:9696`
   - **Sonarr/Radarr Server:** how Prowlarr reaches the app, e.g. `http://sonarr:8989` / `http://radarr:7878` (container names work since they share the `proxy` network)
   - **API Key:** from the *arr app under **Settings → General → Security**
   - **Sync Level:** `Full Sync` (Prowlarr adds, updates, and removes indexers in the app)

   Click **Test**, then **Save**. Prowlarr pushes all configured indexers to the app automatically — don't add indexers directly in Sonarr/Radarr.
5. **Verify** — use **Search** in Prowlarr to run a test query across all indexers, and check **System → Status** for indexer health warnings.

### Download flow

Prowlarr does not handle downloads. It only provides indexer search results to your *arr apps — they in turn send downloads to qBittorrent, SABnzbd, etc.

## Environment Variable Notes

| Variable | Description |
|---|---|
| `PROWLARR_IMAGE` | Container image (default: `ghcr.io/hotio/prowlarr:release`) |
| `PROWLARR_RESTART` | Restart policy (default: `unless-stopped`) |
| `PROWLARR_PORT` | Published port for the web UI (default: `9696`) |
| `FLARESOLVERR_IMAGE` | FlareSolverr image (default: `ghcr.io/flaresolverr/flaresolverr:latest`) |
| `FLARESOLVERR_RESTART` | FlareSolverr restart policy (default: `unless-stopped`) |
| `FLARESOLVERR_LOG_LEVEL` | FlareSolverr log level (default: `info`; use `debug` when troubleshooting) |
| `TZ` | Timezone for FlareSolverr (default: `America/Vancouver`) |
| `VOL_PATH` | Base path for persistent data volumes (default: `/data`) |

## Volume Notes

| Volume | Purpose |
|---|---|
| `${VOL_PATH}/prowlarr/config` | Indexer configurations, app sync settings, database |

## Network Notes

Requires an external `proxy` network. Create it once with:

```bash
docker network create proxy
```

FlareSolverr sits on the stack's `internal` network only — it is not published to the host or the proxy network. Prowlarr joins both and reaches it at `http://flaresolverr:8191/`.

## Docker Run

```bash
docker network create prowlarr-internal

docker run -d \
  --name=flaresolverr \
  -e LOG_LEVEL=info \
  -e TZ=America/Vancouver \
  --network prowlarr-internal \
  --restart unless-stopped \
  ghcr.io/flaresolverr/flaresolverr:latest

docker run -d \
  --name=prowlarr \
  -e PUID=1000 \
  -e PGID=1000 \
  -e UMASK=002 \
  -p 9696:9696 \
  -v ${VOL_PATH:-/data}/prowlarr/config:/config \
  --network proxy \
  --restart unless-stopped \
  ghcr.io/hotio/prowlarr:release

docker network connect prowlarr-internal prowlarr
```

## Additional Notes / Gotchas

- **FlareSolverr only helps tagged indexers** — untagged indexers bypass it. Don't tag everything; it's slow (spins up a headless Chromium per request).
- **Some challenges still fail** — Cloudflare changes often. If tests keep failing, pull the latest FlareSolverr image and set `FLARESOLVERR_LOG_LEVEL=debug` to see why.

## Dockhand Stack, Deploy from Git

- **Cookbooks Repository**
- **stackname:** prowlarr
- **Compose file path:** prowlarr/compose.yaml
- **Additional env file (optional):** prowlarr/sample.env

Load `prowlarr/sample.env` into the Environment variables in Dockhand, then create the Stack.
