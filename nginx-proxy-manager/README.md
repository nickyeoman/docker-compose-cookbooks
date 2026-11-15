# Nginx Proxy Manager

## Overview

Nginx Proxy Manager (NPM) is the reverse proxy in front of every other stack in this repo. I run one instance on each host.

Unlike the other stacks, NPM is normally run with `docker run`, not through Dockhand. If Dockhand is reached by a domain name (FQDN), it can't be reached while the reverse proxy is down, so NPM has to start independently of Dockhand. Set NPM up first.

## Project Details

-   **Project Repository:** [GitHub](https://github.com/NginxProxyManager/nginx-proxy-manager)
-   **Container Image:** [Docker Hub](https://hub.docker.com/r/jc21/nginx-proxy-manager) ([tags](https://hub.docker.com/r/jc21/nginx-proxy-manager/tags))
-   **Documentation:** [nginxproxymanager.com](https://nginxproxymanager.com/)
-   **Exposed Ports:** `80`, `443` (HTTP/HTTPS), `81` (admin UI)

## Getting Started

1. Create the shared network (once per host): `docker network create proxy`
2. Create the volume directories (see [Volume Notes](#volume-notes))
3. Start the container with the [Docker Run](#docker-run) command
4. Open http://localhost:81 and log in with the default credentials, then change them right away:
    * Email: `admin@example.com`
    * Password: `changeme`

## Environment Variable Notes

These apply to the compose file (`sample.env`). The `docker run` command hardcodes the defaults.

    VOL_PATH – base path for data and letsencrypt volumes (default /data)
    LOG_PATH – where NPM logs are written (default /var/log/containers/nginx-proxy-manager)
    PROXY_IMAGE – image and tag to run
    PROXY_RESTART – restart policy (default unless-stopped)
    PROXY_HTTP_PORT / PROXY_HTTPS_PORT / PROXY_ADMIN_PORT – host ports (default 80 / 443 / 81)

## Volume Notes

    /data/nginx-proxy-manager/data – NPM database and config (back this up)
    /data/nginx-proxy-manager/letsencrypt – certificates (back this up)
    /var/log/containers/nginx-proxy-manager – access/error logs

```bash
mkdir -p /data/nginx-proxy-manager/data /data/nginx-proxy-manager/letsencrypt /var/log/containers/nginx-proxy-manager
```

NPM writes logs under `/data/logs` inside the container. They're mounted outside of `VOL_PATH` via `LOG_PATH` so they aren't backed up with the rest of the data. If you'd rather back up/sync logs too, remove the logs volume.

## Network Notes

NPM joins the `proxy` network, which every other stack attaches to as an external network. Create it once per host:

```bash
docker network create proxy
```

Ports 80 and 443 must be exposed. Port 81 (admin UI) can be exposed or proxied through NPM itself.

## Docker Run

This is the usual way to run NPM.

```bash
docker run -d \
  --name nginx-proxy-manager \
  --restart unless-stopped \
  --network proxy \
  -e X_FRAME_OPTIONS="sameorigin" \
  -e DB_SQLITE_FILE="/data/database.sqlite" \
  -p 80:80 \
  -p 81:81 \
  -p 443:443 \
  -v "/data/nginx-proxy-manager/data:/data" \
  -v "/data/nginx-proxy-manager/letsencrypt:/etc/letsencrypt" \
  -v "/var/log/containers/nginx-proxy-manager:/data/logs" \
  jc21/nginx-proxy-manager:latest
```

### Upgrade (and backup)

Back up the data with restic before upgrading so you can restore it if the new version doesn't come up cleanly. Logs aren't needed for a restore.

```bash
restic backup /data/nginx-proxy-manager
```

Then pull the new image and recreate the container:

```bash
docker pull jc21/nginx-proxy-manager:latest
docker stop nginx-proxy-manager
docker rm nginx-proxy-manager
docker run -d \
  --name nginx-proxy-manager \
  --restart unless-stopped \
  --network proxy \
  -e X_FRAME_OPTIONS="sameorigin" \
  -e DB_SQLITE_FILE="/data/database.sqlite" \
  -p 80:80 \
  -p 81:81 \
  -p 443:443 \
  -v "/data/nginx-proxy-manager/data:/data" \
  -v "/data/nginx-proxy-manager/letsencrypt:/etc/letsencrypt" \
  -v "/var/log/containers/nginx-proxy-manager:/data/logs" \
  jc21/nginx-proxy-manager:latest
```

If you're using the compose file instead: `docker compose pull && docker compose up -d`.

If something goes wrong, restore the snapshot with `restic restore latest --target /` (or `restic snapshots` to pick an earlier one) and start the old container again.

## Additional Notes / Gotchas

### Placeholder `headscale-ui` on dev/slave instances

If NPM config is synced from production to dev/slave instances, the proxy host for `headscale-ui` still exists there. NPM checks that the upstream container resolves, and fails if `headscale-ui` isn't on the network. On non-production hosts, run a tiny nginx placeholder that answers with a 503.

1. Create `compose.yaml`:

```yaml
services:
  headscale-ui:
    image: nginx:alpine
    container_name: headscale-ui
    restart: unless-stopped
    volumes:
      - ./default.conf:/etc/nginx/conf.d/default.conf:ro
    networks:
      - proxy

networks:
  proxy:
    external: true
```

2. Create `default.conf` next to it:

```nginx
server {
    listen 80;
    server_name _;

    location / {
        default_type text/plain;
        return 503 "Headscale UI is not available on this node.\n";
    }
}
```

3. Start it with `docker compose up -d`.

## Dockhand Stack, Deploy from Git

Not recommended. NPM isn't deployed through Dockhand, because Dockhand can't be reached by its FQDN while the reverse proxy is down. Use the [Docker Run](#docker-run) command instead. `compose.yaml` is kept for reference and for hosts where Dockhand is reached by IP.
