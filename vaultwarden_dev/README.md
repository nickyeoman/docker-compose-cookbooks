# Vaultwarden

## Overview

Vaultwarden is a lightweight, Bitwarden-compatible password manager
server written in Rust. It works with the official Bitwarden browser
extensions and mobile apps.

## Project Details

-   **Project Repository:** [github.com/dani-garcia/vaultwarden](https://github.com/dani-garcia/vaultwarden)
-   **Container Image:** [Docker Hub](https://hub.docker.com/r/vaultwarden/server)
-   **Documentation:** [Vaultwarden Wiki](https://github.com/dani-garcia/vaultwarden/wiki)
-   **Reverse Proxy Port:** `80`

## Getting Started

1. Copy `sample.env`, set `VAULT_DOMAIN` and a random
   `VAULT_ADMIN_TOKEN` (`openssl rand -base64 48`)
2. Start the container: `docker compose up -d`
3. Open http://localhost:8083/admin, sign in with the admin token, and
   invite your users (signups are disabled by default)

## Environment Variable Notes

    VAULT_DOMAIN – public base URL; Bitwarden clients require https,
      so point this at your reverse-proxy domain for real use
    VAULT_SIGNUPS_ALLOWED – open registration (default false; invite
      users from the admin page instead)
    VAULT_ADMIN_TOKEN – token for the /admin page; leave unset to
      disable the admin page entirely
    SMTP_* – optional mail settings for invitations and password-hint
      emails; set all or none
    VAULT_PORT – host port for the web UI (default 8083)

See the [wiki](https://github.com/dani-garcia/vaultwarden/wiki) for
the full configuration reference.

## Volume Notes

-   `/data` — SQLite database, attachments, icon cache, and RSA keys;
    stored at `${VOL_PATH:-/data}/vaultwarden` on the host. Back this
    up — it is the entire vault.

## Network Notes

Requires proxy network

## Docker Run

```bash
docker run -d \
  --name=vaultwarden \
  -e DOMAIN=https://vault.example.com \
  -e SIGNUPS_ALLOWED=false \
  -e ADMIN_TOKEN=changeme-to-a-long-random-string \
  -p 8083:80 \
  -v /data/vaultwarden:/data \
  vaultwarden/server:latest
```

## Additional Notes / Gotchas

-   This is a `_dev` stack — experimental, not yet production-ready.
-   Bitwarden clients refuse to connect over plain http (except to
    localhost) — serve it through the reverse proxy with TLS.
-   WebSocket notifications are served on the main port since
    Vaultwarden 1.29; no separate `WEBSOCKET_ENABLED` setting or port
    3012 proxying is needed anymore.
-   [Disable registration of new users](https://github.com/dani-garcia/vaultwarden/wiki/Disable-registration-of-new-users)
-   [SMTP configuration](https://github.com/dani-garcia/vaultwarden/wiki/SMTP-configuration)

## Dockhand Stack, Deploy from Git

-   Cookbooks Repository
-   stackname: vaultwarden_dev
-   Compose file path: vaultwarden_dev/compose.yaml
-   Additional env file (optional): vaultwarden_dev/sample.env

Then "Load" vaultwarden_dev/sample.env into the Environment variables in dockhand.

Create the Stack
