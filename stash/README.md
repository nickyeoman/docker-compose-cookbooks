# Stash App Docker Compose Configuration

## Overview

This Docker Compose configuration sets up the Stash application using Docker containers.

- Stash App: [Stash on Docker Hub](https://hub.docker.com/r/stashapp/stash)
- Compose Example: [Stash GitHub Repository](https://github.com/stashapp/stash/blob/develop/docker/production/docker-compose.yml)
- Documentation: https://docs.stashapp.cc/
- ProxyPort: 9999

## Project Details

-   **Container Image:** [stashapp/stash:latest](https://hub.docker.com/r/stashapp/stash)
-   **Reverse Proxy Port:** `9999`

## Getting Started

1. Start the container: `docker compose up -d`
2. Open http://localhost:9999 in your browser
3. Follow the initial setup wizard to configure the application

## Environment Variable Notes

    STASH_CONTENT_PATH – default: /data/stash
    STASHAPP_CACHE – default: /cache/
    STASHAPP_DOMAIN – default: stash.yourdomain.ca
    STASHAPP_PORT – default: 9999

## Volume Notes

    /generated – host path /data/stash/generated
    /metadata – host path /data/stash/metadata
    /root/.stash – host path /data/stash/root
    /data – host path /data/stash

## Network Notes

Requires proxy network

## Docker Run

```bash
docker run -d \
  --name stash \
  -p 9999:9999 \
  -v /data/stash/generated:/generated \
  -v /data/stash/metadata:/metadata \
  -v /data/stash/root:/root/.stash \
  -v /data/stash:/data \
  stashapp/stash:latest
```

See compose.yaml for the full set of environment variables.

## Additional Notes / Gotchas

Point STASH_CONTENT_PATH at your library; first-run wizard configures the library paths.

## Dockhand Stack, Deploy from Git

Cookbooks Repository
stackname: stash
Compose file path: stash/compose.yaml
Additional env file (optional): stash/sample.env

Then "Load" stash/sample.env into the Environmental variables in dockhand

Create the Stack

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
