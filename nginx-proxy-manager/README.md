# Nginx Proxy Manager

## Overview
This Docker Compose configuration sets up the Reverse Proxy application using Docker container.

- App: [Proxy Manager on Docker Hub](https://hub.docker.com/r/jc21/nginx-proxy-manager)
- Official Site: [Nginx Proxy Manager](https://nginxproxymanager.com/)
- Expose ports: 80, 81, 443

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

### env file

```text
# Nginx Proxy Manager
PRODDIR=/var/www/stashdomain-com/ #HELP: project_path
VOL_PATH=/docker/vol/portainer-data #HELP: volpath
COOKBOOK=/home/user/git/docker-compose-cookbooks #HELP: cookbooks
PROXY_IMAGE=jc21/nginx-proxy-manager:2.11.3
```

## Usage

In the project directory you have to run as root as you use port 80 and 443

```bash
# Docker Start
docker-compose up -d

# Docker Stop 
docker-compose down

# Podman Start
sudo podman-compose up -d

# Podman Stop 
sudo podman-compose down
```