# Stash App Docker Compose Configuration

## Overview
This Docker Compose configuration sets up the Stash application using Docker containers.

- Stash App: [Stash on Docker Hub](https://hub.docker.com/r/stashapp/stash)
- Compose Example: [Stash GitHub Repository](https://github.com/stashapp/stash/blob/develop/docker/production/docker-compose.yml)
- ProxyPort: 9999

## Setup

### Data directories

By default the compose file creates volumes locally in the project:

```bash
mkdir -p data/video data/cache data/metadata data/generated data/root/.stash
touch data/root/.stash/config.yml
```

Usually I .gitignore the data directory and use a backup solution.

## Configuration Details

### Environment Variables

#### STASH_IMAGE

Docker image tag for Stash app.
Alternative image found here: https://hotio.dev/containers/stash/

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

In your project file, you can change the network mode to host:
```yaml
services:
  stash:
    ports:
      - "8000:9999"
    network_mode: "host"
```
