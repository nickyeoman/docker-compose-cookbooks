# Nginx Proxy Manager

This doesn't really work in dockhand as you won't have access to a lot of services without this running.
Moved to notes section, run the compose file manually.

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

## Project Setup

See sample-extends.yml

### Create volumes
```bash
mkdir -p data/proxy data/proxy-letsencrypt
```
