# Stash App Docker Compose Configuration

## Overview
This Docker Compose configuration sets up the Stash application using Docker containers.

- Stash App: [Stash on Docker Hub](https://hub.docker.com/r/stashapp/stash)
- Compose Example: [Stash GitHub Repository](https://github.com/stashapp/stash/blob/develop/docker/production/docker-compose.yml)
- ProxyPort: 9999

## Setup

### COOKBOOK SETUP

Clone the repository then set the COOKBOOK Variable in your PROJECT's env file
```
git clone git@github.com:nickyeoman/docker-compose-cookbooks.git
```

### Project Setup

Note this setup is meant to be used between two directories, COOKBOOK and PROJECT.  
In your PROJECT directory set the following env file:

```text
# Local
PROD=prod.domain.com
PRODDIR=/var/www/stashdomain-com/
COOKBOOK=/home/user/git/docker-compose-cookbooks
VOL_PATH=/project-dir/project-name/data
STASH_IMAGE=stashapp/stash:v0.26.2

# Container
STASH_DOMAIN_NAME=stash.4lt.ca
MAX_SIZE=200m
STASH_STASH=/data/
STASH_GENERATED=/generated/
STASH_METADATA=/metadata/
STASH_CACHE=/cache/
```

### Docker Compose Extend

Now using extend you can call the service:

```yaml
version: '3.4'

services:
  stash:
    extends:
      file: ${COOKBOOK}/stashapp/docker-compose.yml
      service: stash
    env_file:
      - .env
    ports:
      - "9999:9999"
```

### Data directories

By default the compose file creates volumes locally in the project:

```bash
mkdir -p data/video data/cache data/metadata data/generated data/root/.stash
touch data/root/.stash/config.yml
```

Usually I .gitignore the data directory and use a backup solution for redundancy.


## Usage

In the project directory just run

```bash
# Docker Start
docker-compose up -d

# Docker Stop 
docker-compose down

# Podman Start
podman-compose up -d

# Podman Stop 
podman-compose down
```

## Configuration Details

### Environment Variables

#### STASH_IMAGE

Docker image tag for Stash app.

#### STASH_DOMAIN_NAME

Domain name for the Stash app.

#### MAX_SIZE

Maximum size for log files.

#### Other

STASH_STASH, STASH_GENERATED, STASH_METADATA, STASH_CACHE: Paths for Stash data directories.

### Volumes

/etc/localtime:/etc/localtime:ro: Mounts host system's timezone information.
./data/video:/data: Maps local ./data/video directory to Stash /data directory.
./data/metadata:/metadata: Maps local ./data/metadata directory to Stash /metadata directory.
./data/cache:/cache: Maps local ./data/cache directory to Stash /cache directory.
./data/generated:/generated: Maps local ./data/generated directory to Stash /generated directory.
./data/root:/root: Maps local ./data/root directory to Stash /root directory.

### Networking

In  your project file, you can change the network mode to host:
```yaml
stash:
    extends:
      file: ${COOKBOOK}/stashapp/docker-compose.yml
      service: stash
    env_file:
      - .env
    ports:
      - "8000:9999"
    network_mode: "host"
```

If you are using a reverse proxy, you need to set that network:

```yaml
networks:
  proxy:
    external: true
```
