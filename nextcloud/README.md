# nextcloud

## Overview

Self-hosted file sync, sharing, and collaboration platform. This stack runs Nextcloud (Apache) with MariaDB, Redis for caching and file locking, and a cron container for background jobs.

## Project Details

-   **Project Repository:** [GitHub](https://github.com/nextcloud/docker)
-   **Container Image:** [nextcloud](https://hub.docker.com/_/nextcloud), [mariadb](https://hub.docker.com/_/mariadb), [redis](https://hub.docker.com/_/redis)
-   **Documentation:** [Admin Manual](https://docs.nextcloud.com/server/latest/admin_manual/)
-   **Reverse Proxy Port:** `80`

## Getting Started

1. Set `NEXTCLOUD_DOMAIN` and change every `ChangeThisPassword` in `sample.env`
2. Start the stack: `docker compose up -d`
3. In NPM, add a proxy host for `NEXTCLOUD_DOMAIN` → `http://nextcloud:80` with SSL enabled
4. Open https://NEXTCLOUD_DOMAIN and create the admin account (the database fields are pre-filled from the environment)

To test without NPM, open http://HOST_IP:8084. Set `NEXTCLOUD_DOMAIN=HOST_IP` and `NEXTCLOUD_OVERWRITEPROTOCOL=http` first. Otherwise Nextcloud rejects the untrusted domain and redirects you to https links that don't work.

## Environment Variable Notes

    NEXTCLOUD_IMAGE – default: nextcloud:35 (pin the major version, see Gotchas)
    MARIADB_IMAGE – default: mariadb:11.8 (the version Nextcloud recommends)
    REDIS_IMAGE – default: redis:alpine
    NEXTCLOUD_DB – default: nextcloud
    NEXTCLOUD_DB_USER – default: nextcloud
    NEXTCLOUD_DB_PASSWORD – default: ChangeThisPassword
    NEXTCLOUD_DB_HOST – default: nextcloud-db
    MARIADB_ROOT_PASSWORD – default: ChangeThisPassword
    NEXTCLOUD_REDIS_HOST – default: nextcloud-redis
    NEXTCLOUD_DOMAIN – public hostname without a scheme; sets trusted_domains (first install only) and overwrite.cli.url
    NEXTCLOUD_TRUSTED_PROXIES – default: 172.16.0.0/12 (Docker bridge range, covers NPM)
    NEXTCLOUD_PORT – default: 8084; host port for testing without NPM (NPM connects to nextcloud:80)
    NEXTCLOUD_OVERWRITEPROTOCOL – default: https; generates https links behind NPM's TLS termination
    VOL_CACHE – default: /var/cache; base path for regenerable data (exclude from backups)
    NEXTCLOUD_PREVIEW_DIR – default: /mnt/nextcloud-preview (unused placeholder); after install, set to /var/www/html/data/appdata_<instanceid>/preview

## Volume Notes

    /var/lib/mysql – host path /data/nextcloud/db (MariaDB data)
    /data – host path /data/nextcloud/redis (Redis cache, safe to lose)
    /var/www/html – host path /data/nextcloud/data (Nextcloud app, config and user files; shared by nextcloud and nextcloud-cron)

    /var/www/html/data/appdata_<instanceid>/preview – host path /var/cache/nextcloud/preview (generated thumbnails; only once NEXTCLOUD_PREVIEW_DIR is set)

Back up `/data/nextcloud/data` and `/data/nextcloud/db` together. Leave out `/var/cache`: previews are regenerated on demand.

### Moving previews to VOL_CACHE

Previews are usually the largest regenerable data, often several GB. They live in a folder named after the instance ID, which Nextcloud only creates during install. That's why the preview mount points at a placeholder until you set `NEXTCLOUD_PREVIEW_DIR`.

1. Get the instance ID: `docker compose exec -u www-data nextcloud php occ config:system:get instanceid`
2. Stop the stack: `docker compose down`
3. Move existing previews and give them to www-data (UID 33):
   ```bash
   sudo mkdir -p /var/cache/nextcloud
   sudo mv /data/nextcloud/data/data/appdata_<instanceid>/preview /var/cache/nextcloud/preview
   sudo mkdir /data/nextcloud/data/data/appdata_<instanceid>/preview
   sudo chown -R 33:33 /var/cache/nextcloud/preview /data/nextcloud/data/data/appdata_<instanceid>/preview
   ```
4. Set `NEXTCLOUD_PREVIEW_DIR=/var/www/html/data/appdata_<instanceid>/preview` and start the stack

If you lose `/var/cache`, don't start with an empty folder: Nextcloud's file cache still lists the old previews. Recreate the folder (owned by 33:33), start the stack, then run `docker compose exec -u www-data nextcloud php occ files:scan-app-data preview`.

## Network Notes

Requires proxy network. `nextcloud` joins `proxy` and `internal`; `nextcloud-db`, `nextcloud-redis` and `nextcloud-cron` join `internal` only.

## Docker Run

Nextcloud needs the database container to run, so use compose. The app container alone looks like this:

```bash
docker run -d \
  --name nextcloud \
  --network proxy \
  -p 8084:80 \
  -e MYSQL_HOST=nextcloud-db \
  -e MYSQL_DATABASE=nextcloud \
  -e MYSQL_USER=nextcloud \
  -e MYSQL_PASSWORD=ChangeThisPassword \
  -v /data/nextcloud/data:/var/www/html \
  nextcloud:35
```

See compose.yaml for the full set of services and environment variables.

## Additional Notes / Gotchas

-   **Upgrade one major version at a time.** Nextcloud can't skip majors (for example 33 → 35 fails). Bump `NEXTCLOUD_IMAGE` step by step and let each version finish its upgrade before moving on.
-   **MariaDB can't be downgraded.** If an existing install has already run a newer `mariadb:latest`, keep `MARIADB_IMAGE` at that version. Data files from a newer MariaDB won't start on 11.8. `MARIADB_AUTO_UPGRADE=1` handles upgrades.
-   **Env vars that only apply on first install:** `NEXTCLOUD_TRUSTED_DOMAINS` and the database settings. For an existing install, set the domain with occ:
    `docker compose exec -u www-data nextcloud php occ config:system:set trusted_domains 1 --value=cloud.example.com`
-   **Background jobs:** after install, go to Administration settings → Basic settings and select **Cron**. The `nextcloud-cron` container runs `cron.php` every 5 minutes.
-   **NPM:** increase the upload limit in the proxy host's Advanced tab (for example `client_max_body_size 10G;`) or large uploads will fail.
-   **Nextcloud All-in-One:** `compose-aio.yaml` is an alternative to this stack, not an add-on. The master container spawns and manages its own containers, so container and volume names are fixed. It doesn't join the `proxy` network. Open the AIO admin UI at https://HOST:8080, then point NPM at `http://HOST_IP:11000` (the `APACHE_PORT`). User data goes to `/data/nextcloud-aio`.

### Useful commands

```bash
docker compose exec -u www-data nextcloud php occ status
docker compose exec -u www-data nextcloud php occ app:list
docker compose exec -u www-data nextcloud php occ app:disable <appname>
docker compose exec -u www-data nextcloud php occ maintenance:mode --on
docker compose exec -u www-data nextcloud php occ trashbin:cleanup --all-users
docker compose exec -u www-data nextcloud php occ db:add-missing-indices
```

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: nextcloud
Compose file path: nextcloud/compose.yaml
Additional env file (optional): nextcloud/sample.env

Then "Load" nextcloud/sample.env into the Environmental variables in dockhand

Create the Stack
