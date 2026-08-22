# Nginx Proxy Manager

Remember, if dockhand is using a domain name, this will have to be set up first.

I run one instance of Nginx Proxy Manager (NPM) on each host.

## Overview

This Docker Compose configuration sets up the Reverse Proxy application using Docker container.

- App: [Proxy Manager on Docker Hub](https://hub.docker.com/r/jc21/nginx-proxy-manager)
- Official Site: [Nginx Proxy Manager](https://nginxproxymanager.com/)
- [Docker tags](https://hub.docker.com/r/jc21/nginx-proxy-manager/tags)
- Expose ports: 80, 81, 443

## Default Login

* Email: admin@example.com
* Password: changeme

## Create Network

The first thing you want to do is create the network:

```bash
docker network create proxy
```

## Expose Ports

80 and 443 must be exposed, but you could proxy to 81 for the admin interface.

### Create volumes

Assuming default sample.env is used:

```bash
mkdir -p /data/nginx-proxy-manager/data /data/nginx-proxy-manager/letsencrypt /var/log/containers/nginx-proxy-manager
```

## Logs

Nginx Proxy Manager writes access/error logs under `/data/logs`, which is mounted outside of `VOL_PATH`. Since logs shouldn't be backed up with the rest of the data, they're mounted separately via `LOG_PATH`, which defaults to `/var/log/containers/nginx-proxy-manager/`. If you'd rather back up/sync logs with the rest of the data, just remove the logs volume.

```bash
mkdir -p /var/log/containers/nginx-proxy-manager
```

## Equivalent docker run command

```bash
mkdir -p /data/nginx-proxy-manager/data /data/nginx-proxy-manager/letsencrypt /var/log/containers/nginx-proxy-manager

docker network create proxy

docker run -d \
  --name proxy \
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
  jc21/nginx-proxy-manager:2.15.1
```
