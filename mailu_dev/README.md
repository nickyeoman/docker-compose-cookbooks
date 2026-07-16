# Mailu

## Overview

Mailu is a self-hosted mail server suite providing SMTP, IMAP, POP3, webmail, and antispam/antivirus filtering. This Docker Compose stack deploys the full Mailu system with persistent storage and an external reverse proxy for the admin/webmail UI.

## Project Details

-   **Project Repository:** [Mailu](https://mailu.io)
-   **Container Image:** [GitHub Container Registry](https://github.com/orgs/Mailu/packages)
-   **Compose Example:** [Mailu Compose Setup](https://mailu.io/2024.06/compose/setup.html)
-   **Documentation:** [Configuration Reference](https://mailu.io/2024.06/configuration.html)
-   **Reverse Proxy Port:** `80` (admin/webmail via `front` container)

## Getting Started

1. Copy `sample.env` to `.env` and edit all values (especially `DOMAIN`, `HOSTNAMES`, `SECRET_KEY`, `TLS_FLAVOR`)
2. Create the required directories under `${VOL_PATH}/mailu/`:
   - `certs/` — TLS certificates (only needed if `TLS_FLAVOR=cert`)
   - `overrides/` — optional service overrides
3. Start the stack: `docker compose up -d`
4. Create the initial admin user:
   ```
   docker compose exec admin flask mailu admin admin example.com 'password'
   ```
   Or use `INITIAL_ADMIN_*` env vars in `.env` for auto-creation.
5. Log in at `https://mail.example.com/admin` and configure domains, users, and aliases.

## Environment Variable Notes

### Compose
-   `VOL_PATH` – base path for persistent data volumes (default: `/data`)
-   `BIND_ADDRESS4` – IPv4 address to bind mail ports (default: empty = all interfaces)
-   `MAILU_VERSION` – Mailu image tag (default: `2024.06`)
-   `MAILU_RESTART` – container restart policy (default: `always`)
-   `MAILU_ORG` – container registry org (default: `ghcr.io/mailu`)
-   `MAILU_WEBMAIL` – webmail image choice (default: `roundcube`)

### Domain
-   `DOMAIN` – primary mail domain (required)
-   `HOSTNAMES` – comma-separated public hostnames (required; first is primary)
-   `POSTMASTER` – local part of the postmaster address (required)

### Security
-   `SECRET_KEY` – random 16+ character string for session encryption (required)
-   `TLS_FLAVOR` – TLS mode: `letsencrypt`, `cert`, `notls` (default: `cert`)

### Network
-   `SUBNET` – Docker network subnet (default: `192.168.203.0/24`)

### Web
-   `WEB_ADMIN` – admin interface path (default: `/admin`)
-   `WEB_WEBMAIL` – webmail path (default: `/webmail`)
-   `WEB_API` – API path (default: `/api`)
-   `SITENAME` – site name in admin panel
-   `WEBSITE` – linked website URL

### Initial Admin
-   `INITIAL_ADMIN_ACCOUNT` – admin username local part
-   `INITIAL_ADMIN_DOMAIN` – admin domain (usually same as `DOMAIN`)
-   `INITIAL_ADMIN_PW` – admin password
-   `INITIAL_ADMIN_MODE` – creation mode: `create`, `ifmissing`, `update`

## Volume Notes

All volumes are rooted at `${VOL_PATH:-/data}/mailu/`:

-   `certs/` – TLS certificate and key files (cert.pem, key.pem)
-   `data/` – admin database and configuration
-   `dkim/` – DKIM signing keys
-   `filter/` – Rspamd spam filter state
-   `mail/` – user mailbox storage
-   `mailqueue/` – outgoing mail queue
-   `overrides/nginx/` – custom nginx config snippets
-   `overrides/dovecot/` – custom Dovecot config
-   `overrides/postfix/` – custom Postfix config
-   `overrides/rspamd/` – custom Rspamd config
-   `overrides/webmail/` – custom webmail config
-   `redis/` – Redis persistence data
-   `webmail/` – webmail plugin data

## Network Notes

-   Requires the external `proxy` network for HTTP/HTTPS access via Nginx Proxy Manager (admin, webmail, API).
-   Mail protocols (SMTP, IMAP, POP3) are published directly on the host via the `front` container.
-   An internal bridge network connects all Mailu services.

## Docker Run

```bash
docker run -d \
  --name=mailu-redis \
  redis:alpine
```

```bash
docker run -d \
  --name=mailu-front \
  --env-file .env \
  -p 25:25 -p 465:465 -p 587:587 \
  -p 110:110 -p 995:995 \
  -p 143:143 -p 993:993 \
  -p 4190:4190 \
  -v /data/mailu/certs:/certs \
  -v /data/mailu/overrides/nginx:/overrides:ro \
  ghcr.io/mailu/nginx:2024.06
```

## Additional Notes / Gotchas

-   **DNS setup is critical.** Ensure MX, A/AAAA, SPF, DKIM, and DMARC records are configured before going live. See [Mailu DNS docs](https://mailu.io/2024.06/dns.html).
-   **Port 25** requires the container to run with `--network host` or proper port publishing. Some ISPs block port 25 — verify before deploying.
-   **TLS certificates** must exist in `certs/cert.pem` and `certs/key.pem` when `TLS_FLAVOR=cert`.
-   **Let's Encrypt** requires ports 80 and 443 to be reachable from the internet and DNS records pointing to the server IP.
-   **Redis** runs without authentication by default — keep it on the internal network only.
-   The `webmail` service uses a Docker Compose profile (`--profile webmail`) and is not started by default.
-   Skip the `antivirus` service to save ~1GB RAM — Mailu works without it.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: mailu
Compose file path: mailu_dev/compose.yaml
Additional env file (optional): mailu_dev/sample.env

Then "Load" mailu_dev/sample.env into the Environmental variables in dockhand

Create the Stack
